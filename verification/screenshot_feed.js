const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto('http://localhost:8080/SHTheads/#/tradesman/feed');

  await page.waitForTimeout(5000);

  await page.screenshot({ path: 'verification/feed_screen.png' });

  await browser.close();
})();
