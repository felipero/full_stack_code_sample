module.exports = {
  parser: 'babel-eslint',
  extends: ['eslint:recommended', 'plugin:react/recommended', 'plugin:prettier/recommended'],
  rules: {
    'linebreak-style': ['error', 'unix'],
    'prettier/prettier': ['error', { trailingComma: 'all' }],
    'react/prefer-stateless-function': 0,
    'react/prop-types': 0,
    'comma-dangle': ['error', 'always-multiline'],
    'max-len': ['error', { code: 150 }],
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'no-unused-modules': ['error', { argsIgnorePattern: '^_' }],
  },
  plugins: ['prettier', 'react'],
  parserOptions: {
    ecmaVersion: 6,
    sourceType: 'module',
    ecmaFeatures: {
      impliedStrict: true,
      jsx: true,
    },
  },
  env: {
    es6: true,
    es2017: true,
    jest: true,
    browser: true,
    node: true,
  },
};
