const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Notice we navigate to the base-href path
  await page.goto('http://localhost:8080/SHTheads/');

  // Wait a bit for the Flutter app to fully render
  await page.waitForTimeout(5000);

  await page.screenshot({ path: 'verification/web_login_base.png' });

  await browser.close();
})();
