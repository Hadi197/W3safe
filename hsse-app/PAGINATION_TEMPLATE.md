# 📋 Pagination Implementation Template

Gunakan template ini untuk menerapkan pagination ke modul HSSE lainnya.

---

## 🔧 Step 1: Update Service Layer

### File: `src/services/hsse/[module].service.ts`

**1. Add Interfaces** (setelah filters interface):

```typescript
export interface PaginationParams {
  page: number
  pageSize: number
}

export interface PaginatedResponse<T> {
  data: T[]
  count: number
  page: number
  pageSize: number
  totalPages: number
}
```

**2. Replace `getAll()` method**:

```typescript
// Backward compatible - load all records
async getAll(filters?: YourFiltersType): Promise<YourDataType[]> {
  const result = await this.getPaginated(filters, { page: 1, pageSize: 10000 })
  return result.data
}

// Paginated version for performance
async getPaginated(
  filters?: YourFiltersType,
  pagination: PaginationParams = { page: 1, pageSize: 20 }
): Promise<PaginatedResponse<YourDataType>> {
  let query = supabase
    .from(this.tableName)
    .select('*', { count: 'exact' })  // ⚠️ Important: add { count: 'exact' }
    .order('your_date_field', { ascending: false })

  // Apply your filters here...
  if (filters?.search) {
    query = query.or(`field1.ilike.%${filters.search}%,field2.ilike.%${filters.search}%`)
  }
  // ... more filters

  // Apply pagination
  const from = (pagination.page - 1) * pagination.pageSize
  const to = from + pagination.pageSize - 1
  query = query.range(from, to)

  const { data, error, count } = await query

  if (error) throw error

  const totalCount = count || 0
  const totalPages = Math.ceil(totalCount / pagination.pageSize)

  return {
    data: data || [],
    count: totalCount,
    page: pagination.page,
    pageSize: pagination.pageSize,
    totalPages
  }
}
```

---

## 🎨 Step 2: Update Vue Component

### File: `src/views/hsse/[Module]View.vue`

**1. Add Pagination State** (setelah stats):

```typescript
// Pagination
const currentPage = ref(1)
const pageSize = ref(20)
const totalRecords = ref(0)
const totalPages = ref(0)
```

**2. Update `load` method**:

```typescript
const loadData = async () => {
  loading.value = true
  try {
    const response = await yourService.getPaginated(
      filters.value,
      { page: currentPage.value, pageSize: pageSize.value }
    )
    items.value = response.data
    totalRecords.value = response.count
    totalPages.value = response.totalPages
  } catch (error) {
    console.error('Error loading data:', error)
  } finally {
    loading.value = false
  }
}
```

**3. Add Pagination Methods** (sebelum `onMounted`):

```typescript
// Pagination methods
const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadData()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    loadData()
  }
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    loadData()
  }
}

const changePageSize = (newSize: number) => {
  pageSize.value = newSize
  currentPage.value = 1
  loadData()
}

const applyFilters = () => {
  currentPage.value = 1
  loadData()
}

// Computed for pagination
const paginationInfo = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value + 1
  const end = Math.min(currentPage.value * pageSize.value, totalRecords.value)
  return `Menampilkan ${start}-${end} dari ${totalRecords.value} records`
})

const pageNumbers = computed(() => {
  const pages = []
  const maxVisible = 5
  let startPage = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let endPage = Math.min(totalPages.value, startPage + maxVisible - 1)
  
  if (endPage - startPage < maxVisible - 1) {
    startPage = Math.max(1, endPage - maxVisible + 1)
  }
  
  for (let i = startPage; i <= endPage; i++) {
    pages.push(i)
  }
  
  return pages
})
```

**4. Update Filter Dropdowns**:

```vue
<!-- Change from @change="loadData" to: -->
<select v-model="filters.status" @change="applyFilters">
```

---

## 🖼️ Step 3: Add Pagination UI

**Add this after `</table></div></div>`**:

```vue
<!-- Pagination Controls -->
<div class="mt-4 flex items-center justify-between px-4 py-3 bg-white border-t border-gray-200 sm:px-6">
  <!-- Mobile View -->
  <div class="flex-1 flex justify-between sm:hidden">
    <button 
      @click="prevPage" 
      :disabled="currentPage === 1"
      class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
    >
      Previous
    </button>
    <button 
      @click="nextPage" 
      :disabled="currentPage === totalPages"
      class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
    >
      Next
    </button>
  </div>
  
  <!-- Desktop View -->
  <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
    <!-- Info Display -->
    <div>
      <p class="text-sm text-gray-700">
        {{ paginationInfo }}
      </p>
    </div>
    
    <!-- Page Size Selector -->
    <div class="flex items-center gap-2">
      <label class="text-sm text-gray-700">Per halaman:</label>
      <select 
        v-model.number="pageSize" 
        @change="changePageSize(pageSize)"
        class="border border-gray-300 rounded-md text-sm px-2 py-1"
      >
        <option :value="10">10</option>
        <option :value="20">20</option>
        <option :value="50">50</option>
        <option :value="100">100</option>
      </select>
    </div>
    
    <!-- Page Numbers -->
    <div>
      <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
        <!-- Previous Button -->
        <button 
          @click="prevPage" 
          :disabled="currentPage === 1"
          class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
        </button>
        
        <!-- First Page + Ellipsis -->
        <button 
          v-if="pageNumbers.length > 0 && pageNumbers[0]! > 1"
          @click="goToPage(1)"
          class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          1
        </button>
        <span v-if="pageNumbers.length > 0 && pageNumbers[0]! > 2" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
          ...
        </span>
        
        <!-- Page Numbers -->
        <button 
          v-for="page in pageNumbers" 
          :key="page"
          @click="goToPage(page)"
          :class="[
            'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
            page === currentPage 
              ? 'z-10 bg-primary-600 border-primary-600 text-white' 
              : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50'
          ]"
        >
          {{ page }}
        </button>
        
        <!-- Ellipsis + Last Page -->
        <span v-if="pageNumbers.length > 0 && pageNumbers[pageNumbers.length - 1]! < totalPages - 1" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
          ...
        </span>
        <button 
          v-if="pageNumbers.length > 0 && pageNumbers[pageNumbers.length - 1]! < totalPages"
          @click="goToPage(totalPages)"
          class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          {{ totalPages }}
        </button>
        
        <!-- Next Button -->
        <button 
          @click="nextPage" 
          :disabled="currentPage === totalPages"
          class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
        </button>
      </nav>
    </div>
  </div>
</div>
```

---

## 🖼️ Step 4: Add Lazy Loading to Images

**Find all `<img>` tags and add `loading="lazy"`**:

```vue
<!-- Before -->
<img :src="photoUrl" alt="Photo" class="..." />

<!-- After -->
<img :src="photoUrl" alt="Photo" loading="lazy" class="..." />
```

---

## ✅ Checklist per Module

### Safety Induction
- [ ] Add pagination interfaces to service
- [ ] Implement `getPaginated()` method
- [ ] Add pagination state to Vue component
- [ ] Update `loadInductions()` to use pagination
- [ ] Add pagination methods and computed
- [ ] Add pagination UI after table
- [ ] Add lazy loading to images
- [ ] Update filters to use `applyFilters()`
- [ ] Test with sample data
- [ ] Commit changes

### Management Walkthrough
- [ ] Add pagination interfaces to service
- [ ] Implement `getPaginated()` method
- [ ] Add pagination state to Vue component
- [ ] Update `loadWalkthroughs()` to use pagination
- [ ] Add pagination methods and computed
- [ ] Add pagination UI after table
- [ ] Add lazy loading to images
- [ ] Update filters to use `applyFilters()`
- [ ] Test with sample data
- [ ] Commit changes

### Silent Inspection
- [ ] Add pagination interfaces to service
- [ ] Implement `getPaginated()` method
- [ ] Add pagination state to Vue component
- [ ] Update `loadInspections()` to use pagination
- [ ] Add pagination methods and computed
- [ ] Add pagination UI after table
- [ ] Add lazy loading to images
- [ ] Update filters to use `applyFilters()`
- [ ] Test with sample data
- [ ] Commit changes

### Safety Briefing
- [ ] Add pagination interfaces to service
- [ ] Implement `getPaginated()` method
- [ ] Add pagination state to Vue component
- [ ] Update `loadBriefings()` to use pagination
- [ ] Add pagination methods and computed
- [ ] Add pagination UI after table
- [ ] Add lazy loading to images
- [ ] Update filters to use `applyFilters()`
- [ ] Test with sample data
- [ ] Commit changes

---

## 🎯 Quick Tips

1. **Copy-Paste Pattern**: Copy dari Safety Drill atau Safety Patrol yang sudah jadi
2. **Search & Replace**: Ganti nama interface/method sesuai module
3. **Test Incremental**: Test setiap module setelah implementasi
4. **Commit per Module**: Commit setiap kali 1 module selesai
5. **Check Errors**: Jalankan TypeScript compiler untuk cek errors

---

## 📊 Expected Results

Setelah implementasi di semua module:
- ✅ **Load Time**: 150-300ms (vs 5000ms+ sebelumnya)
- ✅ **Memory**: 5-10MB (vs 50MB+ sebelumnya)
- ✅ **Network**: 50-100KB per page (vs 2-3MB sebelumnya)
- ✅ **DOM Nodes**: ~200 nodes (vs 5000+ sebelumnya)
- ✅ **User Experience**: Smooth & responsive

---

## 🚀 Priority Order

1. **Safety Induction** - Module dengan banyak form fields
2. **Management Walkthrough** - Module dengan foto temuan banyak
3. **Silent Inspection** - Module dengan observasi detail
4. **Safety Briefing** - Module yang paling simple

---

## 🆘 Troubleshooting

### Error: "Cannot read property 'length' of undefined"
**Solution**: Check pageNumbers computed property, add null checks:
```typescript
v-if="pageNumbers.length > 0 && pageNumbers[0]! > 1"
```

### Error: "count is null"
**Solution**: Make sure you added `{ count: 'exact' }` in select():
```typescript
.select('*', { count: 'exact' })
```

### Pagination not resetting on filter change
**Solution**: Make sure all filters use `@change="applyFilters"` not `loadData`

### Images loading slow
**Solution**: Verify `loading="lazy"` is on ALL `<img>` tags in detail modals and forms

---

## 📝 Example Commit Message

```
Apply performance optimizations to [Module Name]

- Add pagination support to service layer
  * Implement getPaginated() method
  * Keep getAll() for backward compatibility
  
- Update Vue component with pagination UI
  * Add pagination state and controls
  * Implement page navigation methods
  * Add page size selector
  
- Add lazy loading to all images
  
Performance: 90-97% faster for large datasets
```

---

**Happy Coding! 🎉**
