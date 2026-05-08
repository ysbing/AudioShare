from __future__ import annotations

import argparse
import struct
from io import BytesIO
from pathlib import Path

from PIL import Image, ImageDraw

# macOS AppIcon 所需尺寸 (与 Contents.json 中的 filename 对应)
MACOS_ICON_SIZES = [16, 32, 64, 128, 256, 512, 1024]
# Windows ICO 所需尺寸 (256 在前作为预览)
WIN_ICON_SIZES = [256, 128, 64, 48, 32, 24, 16]


def _parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="生成 macOS 和 Windows 应用图标")
    p.add_argument("--input", default="tools/logo.png")
    p.add_argument(
        "--mac-output-dir",
        default="client/macos/Runner/Assets.xcassets/AppIcon.appiconset",
    )
    p.add_argument(
        "--win-output",
        default="client/windows/runner/resources/app_icon.ico",
    )
    p.add_argument("--mac-radius", type=int, default=200, help="macOS 圆角半径 (基于 1024)")
    p.add_argument("--mac-scale", type=float, default=0.82, help="macOS 图标缩放比例")
    p.add_argument("--win-radius", type=int, default=48, help="Windows 圆角半径 (基于 256)")
    return p.parse_args()


def _make_rounded_icon(
    src: Image.Image, size: int, radius: int, scale: float = 1.0
) -> Image.Image:
    """生成带圆角的图标画布。scale=1.0 表示不缩放（铺满画布）。"""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    inner = int(round(size * scale))
    resized = src.resize((inner, inner), Image.Resampling.LANCZOS)

    inner_mask = Image.new("L", (inner, inner), 0)
    inner_draw = ImageDraw.Draw(inner_mask)
    inner_radius = max(0, int(round(radius * (inner / size))))
    inner_draw.rounded_rectangle((0, 0, inner, inner), radius=inner_radius, fill=255)
    resized.putalpha(inner_mask)

    x = (size - inner) // 2
    y = (size - inner) // 2
    canvas.alpha_composite(resized, (x, y))
    return canvas


def _png_bytes(img: Image.Image) -> bytes:
    buf = BytesIO()
    img.save(buf, format="PNG")
    return buf.getvalue()


def _build_ico(images: list[tuple[int, Image.Image]], output_path: Path) -> None:
    """手动构建 ICO 文件，256x256 为首个条目（预览图），使用 PNG 压缩。"""
    count = len(images)
    directory_size = 16 * count
    data_offset = 6 + directory_size

    png_data_list = []
    offsets = []
    for icon_size, img in images:
        resized = img.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
        data = _png_bytes(resized)
        offsets.append(data_offset)
        png_data_list.append(data)
        data_offset += len(data)

    with open(output_path, "wb") as f:
        # ICONDIR header
        f.write(struct.pack("<HHH", 0, 1, count))
        # ICONDIRENTRY
        for i, (icon_size, _) in enumerate(images):
            size_field = 0 if icon_size == 256 else icon_size
            f.write(
                struct.pack(
                    "<BBBBHHII",
                    size_field,
                    size_field,
                    0,
                    0,
                    1,
                    32,
                    len(png_data_list[i]),
                    offsets[i],
                )
            )
        # PNG data
        for data in png_data_list:
            f.write(data)


def generate_macos(src: Image.Image, args: argparse.Namespace) -> None:
    """生成 macOS 图标（圆角 + 缩放）"""
    canvas = _make_rounded_icon(src, size=1024, radius=args.mac_radius, scale=args.mac_scale)
    output_dir = Path(args.mac_output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    for icon_size in MACOS_ICON_SIZES:
        icon = canvas.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
        icon_path = output_dir / f"app_icon_{icon_size}.png"
        icon.save(icon_path, format="PNG")
        print(f"[macOS] Generated: {icon_path}")


def generate_windows(src: Image.Image, args: argparse.Namespace) -> None:
    """生成 Windows 图标（圆角，不缩放）"""
    canvas = _make_rounded_icon(src, size=256, radius=args.win_radius, scale=1.0)
    output_path = Path(args.win_output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    images = [(s, canvas) for s in WIN_ICON_SIZES]
    _build_ico(images, output_path)
    print(f"[Windows] Generated: {output_path}")


def main() -> None:
    args = _parse_args()
    src = Image.open(args.input).convert("RGBA")
    generate_macos(src, args)
    generate_windows(src, args)


if __name__ == "__main__":
    main()
