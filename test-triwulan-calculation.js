// Test triwulan calculation
function calculateTriwulan(dateString) {
  const tanggal = new Date(dateString)
  const bulan = tanggal.getMonth() + 1 // getMonth() returns 0-11, so add 1
  const triwulan = Math.ceil(bulan / 3) // This gives 1, 2, 3, or 4
  return { bulan, triwulan, tahun: tanggal.getFullYear() }
}

// Test cases
console.log('Test Triwulan Calculation:')
console.log('Jan 2024:', calculateTriwulan('2024-01-15')) // Should be Q1
console.log('Apr 2024:', calculateTriwulan('2024-04-15')) // Should be Q2
console.log('Jul 2024:', calculateTriwulan('2024-07-15')) // Should be Q3
console.log('Oct 2024:', calculateTriwulan('2024-10-15')) // Should be Q4
console.log('Dec 2024:', calculateTriwulan('2024-12-15')) // Should be Q4
