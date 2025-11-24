import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.hsse.app',
  appName: 'HSSE App',
  webDir: 'dist',
  plugins: {
    StatusBar: {
      style: 'DARK',
      backgroundColor: '#4F46E5',
      overlaysWebView: false
    }
  }
};

export default config;
