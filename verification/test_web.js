const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  page.on('console', msg => console.log('BROWSER CONSOLE:', msg.text()));
  page.on('pageerror', error => console.log('BROWSER ERROR:', error.message));

  await page.goto('http://localhost:8080/SHTheads/#/tradesman/feed');

  await page.waitForTimeout(5000);

  // Test clicking the Add Review FAB
  await page.click('button[type="button"]'); // Will likely click the FAB since it's the main button on Feed
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'verification/add_review_dialog.png' });

  await browser.close();
})();
