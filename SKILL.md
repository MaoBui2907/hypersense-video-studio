---
name: video-studio
description: Sản xuất phim ngắn 30-60 giây hoàn toàn bằng code bằng Lemo-Opuscar, chỉ dùng 18 style đã chọn. Dùng khi cần promo, explainer, launch clip, social clip hoặc video dữ liệu; có script kiểm tra môi trường và render. Không dùng cho video quay người thật hoặc chỉnh sửa video có sẵn.
---

# Video Studio (bản rút gọn)

Skill công ty để một agent tự làm phim ngắn bằng code với Lemo-Opuscar. Đây là bản rút gọn: chỉ dùng 18 style đã duyệt, cài thư viện một lần, có script kiểm tra và render. Không cần cài 99 style vào quy trình hằng ngày.

## Khi nào dùng

- Promo sản phẩm/tính năng, launch clip, explainer, social clip, video tổng kết số liệu.
- Nội dung có thể dựng từ chữ, số liệu, hình khối, sơ đồ, map, chart.
- Video 30–60 giây, ưu tiên 16:9 hoặc 9:16.

## Khi nào không dùng

- Video cần người thật, phỏng vấn, quay hiện trường, sự kiện thật.
- Chỉnh sửa/cắt/ghép video có sẵn của người dùng.
- Video cần giao trong dưới 30 phút hoặc không có ngân sách token.
- Style nằm ngoài danh sách 18 style bên dưới, trừ khi CEO/CTO duyệt bổ sung.

## Cài đặt một lần

Clone thư viện một lần, cài core deps bằng script của thư viện, rồi kiểm tra:

```sh
export LEMO_HOME="${LEMO_HOME:-$HOME/lemo-opuscar}"
git clone --depth 1 https://github.com/lemomo-ai/lemo-opuscar.git "$LEMO_HOME"
git -C "$LEMO_HOME" fetch --depth 1 origin 3a7132b996be0241c1ea0ab180d519f06e6f10b6
git -C "$LEMO_HOME" checkout 3a7132b996be0241c1ea0ab180d519f06e6f10b6
(cd "$LEMO_HOME" && sh plugin/skills/lemo-opuscar/scripts/setup.sh deps)
sh scripts/doctor.sh
```

`doctor.sh` kiểm tra Node 20+, ffmpeg 7+, Python 3.11+, thư viện và 18 style. Skill không đóng gói script clone/fetch để Paperclip import không bị chặn.

Biến môi trường:

| Biến | Mặc định | Ý nghĩa |
|---|---|---|
| `LEMO_HOME` | `$AGENT_HOME/video-studio/lemo-opuscar` hoặc `~/lemo-opuscar` | Nơi giữ thư viện, phải persistent |
| `LEMO_PIN` | commit trong lệnh clone | Pin phiên bản Lemo-Opuscar |
| `WORKERS` | `2` | Số worker render; 1–3 cho máy yếu |
| `CHECK` | `1` | `0` để bỏ qua readcheck khi render |

## 18 style được duyệt

| Nhóm | Slug | Tên | Dùng cho |
|---|---|---|---|
| Edit & Documentary | `news-package` | Broadcast News Package | Tin tức, sự kiện, bản tin có đồ họa |
| Painting & Illustration | `watercolor` | Watercolor Brush | Câu chuyện, thiên nhiên, giải thích nhẹ |
| Sketch & Board | `whiteboard` | Whiteboard Explainer | Onboarding, giải thích quy trình |
| Traditional Crafts | `ink-wash` | Chinese Ink Wash | Kể chuyện, văn hóa, thương hiệu |
| Print & Printmaking | `risograph` | Risograph Print | Poster động, social, nội dung trẻ |
| Graphic & Type | `swiss-motion` | Swiss Motion Graphics | Brand, explainer sạch, nhịp nhanh |
| Line Diagrams | `blueprint` | Blueprint | Kiến trúc hệ thống, quy trình kỹ thuật |
| Line Diagrams | `teardown` | Exploded Teardown | Phân rã sản phẩm/tính năng, cấu trúc |
| Line Diagrams | `iso-infographic` | Isometric Infographic | Tổng quan hệ sinh thái, sơ đồ khối |
| Cartoons | `rubber-hose` | 1930s Rubber Hose Cartoon | Kể chuyện vui, giải thích nhẹ nhàng |
| Games | `pixel-rpg` | 16-bit Pixel RPG | Sản phẩm game, cộng đồng, retro |
| Film & Tape | `ascii-crt` | CRT ASCII Terminal | Kỹ thuật, terminal, không khí hacker |
| Screens & Interfaces | `dark-keynote` | Dark Tech Keynote | Launch sản phẩm, demo tính năng, công nghệ |
| Screens & Interfaces | `spreadsheet` | Spreadsheet Film | Dữ liệu dạng bảng, so sánh, dashboard |
| Light & Lines | `neon-tubes` | Neon Tubes | Social clip, nhận diện mạnh, teaser |
| 3D & Miniature | `lowpoly-island` | Low-poly Isometric Island | Hệ sinh thái, bản đồ, không gian 3D |
| Instruments & Evidence | `briefing-board` | Engineering Briefing Board | Báo cáo kỹ thuật, thông số, chứng cứ |
| Data & Maps | `dataviz` | Data Storytelling | Số liệu, KPI, báo cáo, thị trường |

18 style phủ đủ 15 nhóm. Đã loại 3 style cần image generator (`manga-panels`, `text-flash-cuts`, `comic-history`); không style nào cần sinh video.

Danh sách máy đọc: `scripts/styles.txt`.

## Quy trình bắt buộc

1. **Brief.** Chốt mục tiêu, đối tượng, thông điệp, CTA, thời lượng, tỷ lệ khung hình, ngôn ngữ, brand asset. Không hỏi lại những gì brief đã trả lời.
2. **Chọn style.** Chỉ chọn trong 18 style trên. Nếu không phù hợp, báo CEO/CTO thay vì tự thêm style.
3. **Treatment.** Viết `TREATMENT.md` trong project folder: 3 phương án cấu trúc, chọn 1, lý do, timeline, lời thoại/chữ trên màn hình, asset cần. Viết trước khi đọc demo của style.
4. **Look frame.** Render 3–5 still bằng code thật, đối chiếu `STYLE.md`; chỉ khi đạt mới sản xuất full.
5. **Sản xuất.** Voice → nhạc → hình → mix → render. Dùng `core/` của thư viện, không sửa `core/` hoặc `styles/`.
6. **QA gate.** Chạy `sh scripts/render.sh <project>`; kiểm tra readcheck, âm lượng, phụ đề, copyright, brand. Chỉ giao khi PASS.

## Lệnh

```sh
# Render video + kiểm tra chữ
sh scripts/render.sh ./my-film 24

# Bỏ readcheck (chỉ khi project chưa có TEXTS)
CHECK=0 sh scripts/render.sh ./my-film 24

# Xem style list
cat scripts/styles.txt
```

Project folder do agent tạo trong workspace hiện tại, chứa tối thiểu:

```text
my-film/
  TREATMENT.md
  index.html          # window.DUR, window.render(t), window.READY
  build.sh            # một lệnh dựng lại video
  out/video.mp4
  CREDITS
```

## QA gate

- `readcheck.mjs` PASS: mọi chữ cần đọc đủ lâu, không tràn khung.
- Voice khớp lời thoại (ASR), không có câu bị cắt.
- Loudness khoảng −14 LUFS, không black frame, phụ đề đúng sync.
- Không dùng logo/nhân vật/nhạc/footage không có quyền; ghi `CREDITS`.
- So contact sheet với poster của style: không lặp cấu trúc demo.
- Xem một lần full-speed có âm thanh trước khi giao.

## Guardrails

- Không sửa `core/` hoặc `styles/` của thư viện; copy kỹ thuật cần dùng vào project.
- Không tự thêm style ngoài danh sách; không publish khi QA chưa PASS.
- Không đưa secret, token hay dữ liệu khách hàng vào prompt/asset.
- Phim tạo ra được dùng thương mại; docs/skill Lemo-Opuscar không được bán lại hoặc nhúng vào sản phẩm thương mại nếu chưa có license riêng.
- Pin commit khi triển khai; nâng cấp có kiểm soát.

## Giao hàng

- `<name>.mp4`, `poster.jpg`, `.srt` nếu có lời, `TREATMENT.md`, `CREDITS`, source + `build.sh`.
- Báo cho người yêu cầu: vị trí file, thời lượng, tỷ lệ khung, style, và những điểm cần họ xác nhận.

## Troubleshooting

- `ffmpeg` thiếu hoặc < 7: cài ffmpeg 7+; không dùng ffmpeg 6 vì loudnorm đo sai.
- WebGL context lost: giảm `WORKERS=1`, dùng style 2D, hoặc `LEMO_ANGLE=swiftshader` (chậm).
- Không có Chrome headless: chạy lại lệnh cài core deps trong thư viện; kiểm tra `node_modules/playwright-core`.
- Tiếng Việt: TTS mặc định chỉ Anh/Trung; nếu cần lời Việt, nối edge-tts `vi-VN-HoaiMyNeural`/`vi-VN-NamMinhNeural` và kiểm tra lại bằng tai.
