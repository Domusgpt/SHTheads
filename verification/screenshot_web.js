const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto('http://localhost:8080');

  // Wait a bit for the Flutter app to fully render
  await page.waitForTimeout(5000);

  await page.screenshot({ path: 'verification/web_login.png' });

  await browser.close();
})();
