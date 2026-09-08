# Wecleanvr.com — ผลสำรวจหลังบ้าน และแผนงานที่ต้องทำต่อ

> เอกสารส่งต่องาน สำรวจเมื่อ 2026-09-08 ผ่าน WordPress REST API สาธารณะ (อ่านอย่างเดียว ยังไม่ได้แก้อะไรบนเว็บ)
>
> **หมายเหตุ:** ไฟล์นี้อยู่ใน repo `wecrafttravel` เพราะเป็น repo เดียวที่เซสชันเข้าถึงได้ ตัวเว็บ Wecleanvr.com เป็น WordPress ไม่ได้อยู่ใน repo นี้

## สภาพเว็บ

| หัวข้อ | ค่าที่ตรวจพบ |
| --- | --- |
| ชื่อเว็บ | We Clean VR — "ให้บริการฉีดพ่นกำจัดเชื้อโรคด้วย น้ำอิเล็กโทรไลต์ Steri Plant" |
| ระบบ | WordPress 7.1 (core ใหม่ อัปเดตอัตโนมัติอยู่) |
| ธีม | `sanitizex` (+ ปลั๊กอิน `sanitizex-core`) |
| หน้าเว็บ | 16 หน้า, บทความ 44 ชิ้น, สินค้า 1 ชิ้น |
| Web server | nginx, HTTPS ใช้งานได้ (HTTP พอร์ต 80 ไม่ได้ทดสอบ) |
| ปลั๊กอินหลัก | Elementor + Elementor Pro, ElementsKit, Happy Addons, Templately, Envato Elements, WooCommerce, Contact Form 7, Yoast SEO, Popup Maker, Chaty, Mailchimp for WP, Google Site Kit, Redux Framework, WP Toolkit (Plesk) |
| Application Passwords | เปิดใช้งานได้ (`/wp-admin/authorize-application.php`) |

## รายการปัญหา เรียงตามลำดับที่ควรแก้

### 🔴 ด่วน — ความปลอดภัย

**A1. ปลั๊กอินค้างเวอร์ชันมา ~5 ปี**
- WooCommerce **5.7.1** (ออกปี 2021) — เสี่ยงที่สุด ปลั๊กอินร้านค้าที่ค้างขนาดนี้มีช่องโหว่ที่ประกาศต่อสาธารณะไปแล้วหลายรายการ
- Site Kit by Google **1.49.1** (ปี 2021)
- ต้องทำผ่าน wp-admin (REST API อัปเดตปลั๊กอินไม่ได้)
- **ต้องสำรองเว็บก่อนเสมอ** ข้ามหลายเวอร์ชันมีโอกาสหน้าเว็บพัง ถ้าโฮสต์เป็น Plesk (พบร่องรอย WP Toolkit) จะมีปุ่ม backup + staging ให้ทดสอบก่อน

**A2. ชื่อผู้ใช้แอดมินเปิดสาธารณะ**
- `https://wecleanvr.com/wp-json/wp/v2/users` ตอบ 200 เปิดเผย 2 บัญชี: `wecleanadmin` (id 1, ชื่อแสดง "admin"), `wecraftsale` (id 2, "Niyada Thongtiem")
- เท่ากับให้ชื่อผู้ใช้ฟรีแก่คนที่จะมาสุ่มเดารหัสผ่าน ควรปิด endpoint นี้สำหรับผู้ใช้ที่ไม่ได้ล็อกอิน

**A3. `xmlrpc.php` เปิดอยู่** — ตอบ 200 เป็นช่องเดารหัสผ่านรัวและถูกใช้ขยาย DDoS ปิดได้ถ้าไม่ได้ใช้แอป WordPress มือถือ / Jetpack

### 🟠 กระทบภาพลักษณ์และยอดขายทันที

**B1. สินค้า demo ของ WooCommerce ยังเปิดขายจริง**
- ID 520 "Babyganics Toy & Highchair Cleaner Spray, Fragrance Free"
- SKU `woo-hoodie-with-logo` (ของชุดตัวอย่าง WooCommerce)
- คำอธิบายเป็น Lorem Ipsum ภาษาละติน ("Pellentesque habitant morbi tristique...")
- ราคา ฿45
- เป็นสินค้าชิ้นเดียวในร้าน และหน้า /shop/ /cart/ /checkout/ เปิดอยู่ครบ อยู่ใน sitemap ให้ Google เก็บด้วย
- **ตัดสินใจก่อน:** จะขายของออนไลน์จริงไหม ถ้าไม่ ควรปิด WooCommerce ทั้งชุด (ลดช่องโหว่ + ลดน้ำหนักหน้าเว็บไปในตัว)

**B2. หน้าซ้ำ/หน้าขยะที่ยัง publish**
| ID | ชื่อ | ปัญหา |
| --- | --- | --- |
| 2 | Sample Page | หน้าตัวอย่างที่ WordPress แถมมาตอนติดตั้ง ยัง publish และอยู่ใน sitemap |
| 9 และ 513 | Shop | ซ้ำกัน 2 หน้า ชี้ URL `/shop/` เดียวกัน |
| 2296, 2309 | แชร์ทริคเติมรักวันวาเลนไทน์ | ทำเป็น page ซ้ำ 2 อัน ทั้งที่มีเป็น post อยู่แล้ว (ID 2306) → duplicate content |

**B3. Google Analytics ตัวเก่ายังยิงอยู่**
- พบทั้ง `UA-207440372-1` (Universal Analytics ที่ Google ปิดไปตั้งแต่ปี 2023 ไม่เก็บข้อมูลแล้ว) และ `G-KHXE4SWDE7` (GA4)
- ควรถอด UA ตัวเก่าออก (น่าจะตั้งอยู่ใน Site Kit หรือ header script ของธีม)

### 🟡 SEO และความเร็ว

**C1. หน้าแรกไม่มี meta description** — Yoast ติดตั้งแล้วแต่ไม่ได้กรอก และ `<title>` เป็นแค่ "Home - We Clean VR" ไม่มีคีย์เวิร์ดบริการ ควรใส่คำที่ลูกค้าค้นจริง เช่น "ฉีดพ่นฆ่าเชื้อ", "กำจัดเชื้อโรค", "Steri Plant"

**C2. `robots.txt` ไม่ประกาศ sitemap** — ตอนนี้มีแค่ `Disallow: /wp-admin/` + `Allow: /wp-admin/admin-ajax.php` ทั้งที่ sitemap ใช้งานได้จริงที่ `/sitemap_index.xml` ควรเพิ่มบรรทัด `Sitemap: https://wecleanvr.com/sitemap_index.xml`

**C3. URL ภาษาไทยเป็น percent-encoded** — เช่นหน้าติดต่อเราเป็น `/%e0%b8%95%e0%b8%b4%e0%b8%94...` ยาวและแชร์ยาก ควรเปลี่ยน slug เป็นอังกฤษ (เช่น `/contact/`) **พร้อมทำ 301 redirect จาก URL เดิม** ไม่งั้นลิงก์เก่าที่เคยแชร์ไว้จะพัง

**C4. หน้าแรกหนัก** — HTML 358 KB, CSS 35 ไฟล์, JS 33 ไฟล์, โหลด ~5.1 วินาที ต้นเหตุคือ Elementor + addon หลายตัวซ้อนกัน (ElementsKit, Happy Addons, Templately, Envato Elements, Popup Maker, Chaty) แนวทาง: ถอด addon ที่ไม่ได้ใช้จริง + ติดปลั๊กอิน cache

### ✅ จุดที่ดีอยู่แล้ว
- WordPress core เป็นเวอร์ชันล่าสุด
- Yoast SEO ทำ sitemap ให้ครบ (บทความ 44 ชิ้นเข้า sitemap หมด)
- การลงบทความกลับมาเดินแล้ว เงียบไปช่วงกลางปี 2022 – ปลายปี 2025 แต่ตั้งแต่ พ.ย. 2025 ถึง ก.ย. 2026 ลงต่อเนื่อง

## ลำดับงานที่แนะนำ

1. สำรองเว็บ (backup)
2. อัปเดตปลั๊กอินทั้งหมด โดยเฉพาะ WooCommerce — ทดสอบบน staging ก่อนถ้ามี
3. ตัดสินใจเรื่องร้านค้า แล้วลบสินค้า demo (B1)
4. ลบหน้าขยะและหน้าซ้ำ (B2)
5. ปิดช่องโหว่ user enumeration + xmlrpc (A2, A3)
6. ถอด UA เก่า (B3)
7. งาน SEO: meta description, robots.txt, slug ไทย (C1–C3)
8. ปรับความเร็ว (C4)

## แบ่งงาน: อะไรทำผ่าน API ได้ / อะไรต้องกดใน wp-admin

**Claude ทำได้ผ่าน REST API** (เมื่อมี Application Password): ลบ/แก้/สร้างหน้าและบทความ, ลบสินค้า, แก้ title และ meta description, แก้ slug, อัปโหลดรูป, จัดหมวดหมู่และเมนู

**ต้องคุณกดเองใน wp-admin** (REST API ทำไม่ได้): อัปเดต/ติดตั้ง/ปิดปลั๊กอิน, แก้ไฟล์ธีมหรือ `functions.php`, ปิด xmlrpc และ user enumeration, แก้ robots.txt, ตั้งค่า Site Kit, ทำ backup — Claude เขียนขั้นตอนหรือโค้ดให้วางได้

## การเข้าถึงจากเซสชัน Claude Code

**1. Network access** — ทำแล้ว ✅ environment ตั้งเป็น **Custom** พร้อมโดเมน:
```
wecleanvr.com
*.wecleanvr.com
```
(ติ๊ก "Also include default list of common package managers" ไว้ด้วย) — network policy มีผลทันทีกับเซสชันที่รันอยู่

**2. Environment variables** — ตั้งในกล่อง Update cloud environment เดียวกัน:
```
WP_URL=https://wecleanvr.com
WP_USER=<username ที่สร้าง application password>
WP_APP_PASSWORD=<24 ตัวอักษร 6 กลุ่มคั่นเว้นวรรค>
```
สร้าง Application Password ที่ wp-admin → Users → Profile → Application Passwords → ตั้งชื่อ → Add (WordPress แสดงค่าครั้งเดียว)

⚠️ **environment variables มีผลกับเซสชันที่เปิดใหม่เท่านั้น** เซสชันที่รันอยู่จะยังใช้ค่าเดิมที่ก๊อปไปตอนเริ่ม — ตั้งค่าเสร็จต้องเปิดเซสชันใหม่

**วิธีทดสอบว่าต่อได้** (รันในเซสชันใหม่):
```bash
curl -sS -u "$WP_USER:$WP_APP_PASSWORD" \
  "$WP_URL/wp-json/wp/v2/users/me?_fields=id,name,slug,capabilities" | head -c 400
```
ได้ข้อมูลผู้ใช้กลับมา = ต่อได้ ถ้าได้ `401 rest_not_logged_in` = username หรือรหัสไม่ตรง

**ข้อควรระวัง:** ค่าในช่อง Environment variables ใครที่ใช้ environment นี้ก็อ่านได้ ถ้าอยู่แผน Pro/Max ให้ใช้ช่อง **API credentials** ที่อยู่ใต้ Environment variables แทน จะเก็บรหัสไว้นอกแซนด์บ็อกซ์ และใช้ **Application Password เท่านั้น** ห้ามใช้รหัสผ่านหลักของแอดมิน (ถอน Application Password ทีหลังได้โดยไม่กระทบรหัสหลัก)

---

## อัปเดตเพิ่มเติม (2026-09-08 หลังเข้าดูหน้า WP Toolkit จริง)

### คะแนนความเสี่ยงและเวอร์ชันที่ต้องอัปเดต

WP Toolkit ให้คะแนน **Security Risk 7.9/10** และขึ้นสถานะ Protection Disabled + Updates are available + Essential Measures Not Applied

| ปลั๊กอิน | เวอร์ชันปัจจุบัน | อัปเดตเป็น | คะแนนเสี่ยง |
| --- | --- | --- | --- |
| WooCommerce | 5.7.1 | 11.1.0 | 6.7 |
| Google Tag Manager for WordPress | 1.14.2 | 2.0.1 | 5.1 |
| Elementor | 3.5.5 | 4.2.4 | 2.6 |
| Happy Elementor Addons | 3.4.2 | 3.23.1 | 2.0 |
| Yoast SEO | 18.1 | 28.4 | 1.9 |

(ยังมีรายการต่อจากนี้ที่ยังไม่ได้ดู ต้องเลื่อนหน้า Vulnerabilities ลงไปดูเพิ่ม โดยเฉพาะ **Elementor Pro** ว่าเวอร์ชันอะไรและ license ยังใช้ได้ไหม)

**ปลั๊กอินที่พบเพิ่มจากเมนู wp-admin:** Html5 Video Player, Sanitizex (ธีม), Popup Maker, Contact Form 7 (เมนู Contact), Site Kit

### ⚠️ WP Toolkit เป็นรุ่นจำกัด — ฟีเจอร์ความปลอดภัยเป็นของเสียเงิน

ทดสอบกดแล้วทั้ง **Enable Protection** (Patchstack) และ **Apply Essential Measures** เด้งหน้าให้ซื้อ license ทั้งคู่ (`Waiting for purchase completion`)

**ข้อสรุป: ไม่ต้องซื้อ** ใช้ไฟล์ `wecleanvr/mu-plugins/wecleanvr-hardening.php` ใน repo นี้แทน ทำงานเทียบเท่าฟรี ส่วนการอัปเดตปลั๊กอินกดเองได้ฟรีอยู่แล้ว

ค่อยกลับมาพิจารณา Patchstack ทีหลังเฉพาะกรณีที่ Elementor Pro หมดอายุจนอัปเดตไม่ได้จริง ๆ แล้วต้องปล่อยให้ค้างเวอร์ชันเก่าต่อไป

### 🆕 A4. WP_DEBUG เปิดค้างบนเว็บจริง

หน้า wp-admin แสดงข้อความ:
```
category_name argument is deprecated since version 3.5.0! in
/var/www/vhosts/wecleanvr.com/httpdocs/wp-content/plugins/elementor/modules/dev-tools/deprecation.php on line 301
```
เป็นการเปิดเผย path จริงบนเซิร์ฟเวอร์ (information disclosure) และทำให้หน้าเว็บดูไม่เรียบร้อย

**วิธีแก้:** Plesk File Manager → เปิด `/var/www/vhosts/wecleanvr.com/httpdocs/wp-config.php` → หาบรรทัด `define( 'WP_DEBUG', true );` → เปลี่ยนเป็น:
```php
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_DEBUG_LOG', true );   // ยังเก็บ log ไว้ที่ wp-content/debug.log แต่ไม่แสดงบนหน้าเว็บ
```

**path จริงบนเซิร์ฟเวอร์ (ยืนยันจากข้อความ error):** `/var/www/vhosts/wecleanvr.com/httpdocs/`

### ไฟล์ที่เตรียมไว้ให้แล้วใน repo นี้

`wecleanvr/mu-plugins/wecleanvr-hardening.php` — must-use plugin ทดแทน Essential Measures แบบฟรี ครอบคลุม:

1. ปิด XML-RPC (แก้ A3)
2. ปิด REST API user enumeration (แก้ A2)
3. ปิดการเดาชื่อผู้ใช้ผ่าน `?author=1`
4. ปิดการแก้ไฟล์ธีม/ปลั๊กอินจากหน้า admin (`DISALLOW_FILE_EDIT`)
5. ไม่ให้ PHP error แสดงบนหน้าเว็บ (กันชั้นแรกของ A4)
6. ซ่อนเลขเวอร์ชัน WordPress

**ติดตั้ง:** อัปโหลดเข้า `/var/www/vhosts/wecleanvr.com/httpdocs/wp-content/mu-plugins/` (สร้างโฟลเดอร์ถ้ายังไม่มี) ไฟล์ใน mu-plugins ทำงานเองไม่ต้อง activate และถอนได้โดยลบไฟล์ทิ้ง

**ข้อควรระวังก่อนติดตั้ง:**
- ถ้าใช้แอป WordPress บนมือถือ หรือใช้ Jetpack → ต้องลบส่วนปิด XML-RPC ออก
- ถ้าเว็บมีหน้ารวมบทความรายผู้เขียนที่ใช้จริง → ต้องลบส่วนที่ 3 ออก

### คำถามที่ยังรอคำตอบจากเจ้าของเว็บ

1. **เว็บนี้ขายของออนไลน์จริงไหม?** ถ้าไม่ → Deactivate WooCommerce ทิ้ง ตัดความเสี่ยง 6.7 ฟรีโดยไม่ต้องอัปเดตข้าม 6 เวอร์ชัน
2. **Elementor Pro license ยังไม่หมดอายุใช่ไหม?** ถ้าหมดแล้วจะอัปเดต Pro ไม่ได้ และห้ามอัปเดต Elementor ตัวฟรีเป็น 4.x เด็ดขาด (เว็บพังแน่นอน)
