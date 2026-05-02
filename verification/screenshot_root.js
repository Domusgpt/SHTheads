const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Navigate explicitly to the root hash route
  await page.goto('http://localhost:8080/SHTheads/#/');

  await page.waitForTimeout(5000);

  await page.screenshot({ path: 'verification/root_screen.png' });

  await browser.close();
})();
