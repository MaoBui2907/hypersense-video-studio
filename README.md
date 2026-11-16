# Video Studio Skill

Skill công ty rút gọn để một coding agent tự sản xuất phim ngắn 30–60 giây hoàn toàn bằng code với [Lemo-Opuscar](https://github.com/lemomo-ai/lemo-opuscar). Không dùng model sinh video; không style nào yêu cầu image generator.

## Nội dung

```text
SKILL.md
scripts/doctor.sh
scripts/render.sh
scripts/styles.txt
```

**26 style, phủ đủ 15 nhóm, gồm gói Kids & Education 8 style:**

| Nhóm | Style |
|---|---|
| Edit & Documentary | Broadcast News Package (`news-package`) |
| Painting & Illustration | Watercolor Brush, Crayon Picture Book, Colored-Pencil Science Illustration (`watercolor`, `crayon-book`, `colored-pencil`) |
| Sketch & Board | Whiteboard Explainer, Chalkboard, Sketchnote, Stick-figure Explainer (`whiteboard`, `chalkboard`, `sketchnote`, `stick-explainer`) |
| Traditional Crafts | Chinese Ink Wash (`ink-wash`) |
| Print & Printmaking | Risograph Print (`risograph`) |
| Graphic & Type | Swiss Motion Graphics (`swiss-motion`) |
| Line Diagrams | Blueprint, Exploded Teardown, Isometric Infographic, Instruction Manual Art (`blueprint`, `teardown`, `iso-infographic`, `instruction-manual`) |
| Cartoons | 1930s Rubber Hose Cartoon, Mid-century Cartoon (`rubber-hose`, `midcentury-toon`) |
| Games | 16-bit Pixel RPG (`pixel-rpg`) |
| Film & Tape | CRT ASCII Terminal (`ascii-crt`) |
| Screens & Interfaces | Dark Tech Keynote, Spreadsheet Film (`dark-keynote`, `spreadsheet`) |
| Light & Lines | Neon Tubes (`neon-tubes`) |
| 3D & Miniature | Low-poly Isometric Island, Paper Pop-up Book (`lowpoly-island`, `paper-popup`) |
| Instruments & Evidence | Engineering Briefing Board (`briefing-board`) |
| Data & Maps | Data Storytelling (`dataviz`) |

**Kids & Education pack:** `crayon-book`, `paper-popup`, `midcentury-toon`, `chalkboard`, `sketchnote`, `stick-explainer`, `instruction-manual`, `colored-pencil`.

Đã loại 3 style cần image generator: `manga-panels`, `text-flash-cuts`, `comic-history`. Không style nào cần sinh video; `paper-popup`/`brick-toy` kiểu 3D cần GPU.

## Cài đặt

Yêu cầu: Node 20+, ffmpeg 7+, Python 3.11+ (hoặc `uv`), ~1 GB đĩa; GPU chỉ cần cho style 3D.

```sh
git clone https://github.com/MaoBui2907/video-studio-skill.git
cd video-studio-skill
export LEMO_HOME="${LEMO_HOME:-$HOME/lemo-opuscar}"
git clone --depth 1 https://github.com/lemomo-ai/lemo-opuscar.git "$LEMO_HOME"
git -C "$LEMO_HOME" fetch --depth 1 origin 3a7132b996be0241c1ea0ab180d519f06e6f10b6
git -C "$LEMO_HOME" checkout 3a7132b996be0241c1ea0ab180d519f06e6f10b6
(cd "$LEMO_HOME" && sh plugin/skills/lemo-opuscar/scripts/setup.sh deps)
sh scripts/doctor.sh
```

`scripts/` chỉ chứa kiểm tra và render; không có script clone/fetch để Paperclip import không bị chặn. Mặc định `LEMO_HOME` là `$AGENT_HOME/video-studio/lemo-opuscar` nếu có `AGENT_HOME`, ngược lại `~/lemo-opuscar`.

## Import vào Paperclip

Dùng nguồn GitHub của Paperclip:

1. Chọn **Add skill from GitHub** (hoặc mục import skill source).
2. Repository URL: `https://github.com/MaoBui2907/video-studio-skill`
3. Branch/tracking ref: `main`
4. Skill path: `/` (repo root)
5. Pin commit SHA của lần push gần nhất.

Repo đặt `SKILL.md` ở root để Paperclip nhận diện là một skill package. Nếu UI yêu cầu path tới file, dùng `SKILL.md`.

## Sử dụng

```sh
sh scripts/render.sh ./my-film 24
```

Xem `SKILL.md` cho quy trình brief → treatment → look frame → sản xuất → QA → giao hàng.

## License

- Wrapper skill và scripts: MIT (xem `LICENSE`).
- Lemo-Opuscar upstream: docs/STYLE.md là CC BY-NC 4.0 kèm quyền bổ sung để làm phim; code MIT; phim tạo ra được dùng thương mại. Không redistribute docs/skill upstream như một sản phẩm thương mại khi chưa có license riêng. Xem `NOTICE.md`.
