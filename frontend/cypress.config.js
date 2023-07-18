const { defineConfig } = require("cypress");

module.exports = defineConfig({
  blockHosts: [
    '*google-analytics.com',
  ],
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    baseUrl: 'http://127.0.0.1:5500/frontend/src'
  },
});
