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
