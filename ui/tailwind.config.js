const { join } = require('path');

/** @type {import('tailwindcss').Config} */
module.exports = {
  important: true,
  content: [join(__dirname, 'src/**/!(*.stories|*.spec).{ts,html}')],
  theme: {
    extend: {
      colors: {
        black: '#000',
        white: '#fff',
        'primary-900': 'var(--primary-900)',
        'primary-800': 'var(--primary-800)',
        'primary-700': 'var(--primary-700)',
        'primary-600': 'var(--primary-600)',
        'primary-500': 'var(--primary-500)',
        'primary-400': 'var(--primary-400)',
        'primary-300': 'var(--primary-300)',
        'primary-200': 'var(--primary-200)',
        'primary-100': 'var(--primary-100)',
        'primary-50': 'var(--primary-50)',
        'primary-white': 'var(--primary-white)',
        'primary-black': 'var(--primary-black)',
        'secondary-900': 'var(--secondary-900)',
        'secondary-800': 'var(--secondary-800)',
        'secondary-700': 'var(--secondary-700)',
        'secondary-600': 'var(--secondary-600)',
        'secondary-500': 'var(--secondary-500)',
        'secondary-400': 'var(--secondary-400)',
        'secondary-300': 'var(--secondary-300)',
        'secondary-200': 'var(--secondary-200)',
        'secondary-100': 'var(--secondary-100)',
        'secondary-50': 'var(--secondary-50)',
        'secondary-white': 'var(--secondary-white)',
        'secondary-black': 'var(--secondary-black)',
        'gray-900': 'var(--gray-900)',
        'gray-800': 'var(--gray-800)',
        'gray-700': 'var(--gray-700)',
        'gray-600': 'var(--gray-600)',
        'gray-500': 'var(--gray-500)',
        'gray-400': 'var(--gray-400)',
        'gray-300': 'var(--gray-300)',
        'gray-200': 'var(--gray-200)',
        'gray-100': 'var(--gray-100)',
        'gray-50': 'var(--gray-50)',
        'error-50': 'var(--error-50)',
        'error-100': 'var(--error-100)',
        'error-200': 'var(--error-200)',
        'error-300': 'var(--error-300)',
        'error-400': 'var(--error-400)',
        'error-500': 'var(--error-500)',
        'error-600': 'var(--error-600)',
        'error-700': 'var(--error-700)',
        'error-800': 'var(--error-800)',
        'error-900': 'var(--error-900)',
        'success-500': 'var(--success-500)',
        'success-50': 'var(--success-50)',
        'warn-900': 'var(--warn-900)',
        'warn-100': 'var(--warn-100)',
        'support-1-900': 'var(--support-1-900)',
        'support-1-700': 'var(--support-1-700)',
        'support-1-600': 'var(--support-1-600)',
        'support-1-500': 'var(--support-1-500)',
        'support-1-400': 'var(--support-1-400)',
        'support-1-300': 'var(--support-1-300)',
        'support-1-100': 'var(--support-1-100)',
        'support-1-50': 'var(--support-1-50)',
        'support-1-800': 'var(--support-1-800)',
        'support-1-200': 'var(--support-1-200)',
        'support-2-800': 'var(--support-2-800)',
        'support-2-900': 'var(--support-2-900)',
        'support-2-700': 'var(--support-2-700)',
        'support-2-600': 'var(--support-2-600)',
        'support-2-500': 'var(--support-2-500)',
        'support-2-400': 'var(--support-2-400)',
        'support-2-300': 'var(--support-2-300)',
        'support-2-200': 'var(--support-2-200)',
        'support-2-100': 'var(--support-2-100)',
        'support-2-50': 'var(--support-2-50)',
      },
    },
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
        sm: '2rem',
        lg: '4rem',
        xl: '5rem',
        '2xl': '6rem',
      },
    },
  },
  plugins: [],
};
