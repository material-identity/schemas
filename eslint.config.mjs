import globals from 'globals';
import pluginJs from '@eslint/js';

export default [
  {
    ignores: [
      'node_modules/**',
      'target/**',
      'dist/**',
      'tmp/**',
      'build/**',
      'src/main/resources/static/**',
      'src/test/resources/**',
      'ui/**',
      '**/*.min.js',
      '*-lock.json'
    ]
  },
  { files: ['**/*.{js,mjs,cjs,ts}'] },
  { files: ['**/*.js'], languageOptions: { sourceType: 'commonjs' } },
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.jest,
      },
    }
  },
  pluginJs.configs.recommended,
];
