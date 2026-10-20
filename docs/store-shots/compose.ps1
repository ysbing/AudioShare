Add-Type -AssemblyName System.Drawing

$out = "D:\AudioShare\docs\store-shots"
$src = "$out\src"
$W = 1920
$H = 1080

function New-Canvas {
    $bmp = New-Object System.Drawing.Bitmap $W, $H
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $rect = New-Object System.Drawing.Rectangle 0, 0, $W, $H
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, ([System.Drawing.Color]::FromArgb(255, 235, 241, 252)), ([System.Drawing.Color]::FromArgb(255, 251, 252, 255)), 45.0
    $g.FillRectangle($brush, $rect)
    $brush.Dispose()

    $c1 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(36, 103, 80, 164))
    $g.FillEllipse($c1, 1470, -280, 800, 800)
    $g.FillEllipse($c1, -240, 740, 640, 640)
    $c1.Dispose()
    return @($bmp, $g)
}

function Add-Window {
    param($g, $file, $x, $y, $w, $h)

    for ($i = 20; $i -ge 1; $i--) {
        $a = [int](22 * (1 - ($i / 21.0)))
        $sb = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($a, 20, 32, 58))
        $g.FillRectangle($sb, ($x - $i + 4), ($y - $i + 12), ($w + 2 * $i), ($h + 2 * $i))
        $sb.Dispose()
    }

    $img = [System.Drawing.Image]::FromFile($file)
    $dest = New-Object System.Drawing.Rectangle $x, $y, $w, $h
    $g.DrawImage($img, $dest)
    $img.Dispose()

    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, 30, 45, 80)), 1.5
    $g.DrawRectangle($pen, $x, $y, $w, $h)
    $pen.Dispose()
}

function Add-Text {
    param($g, $text, $x, $y, $size, $style, $color, $maxWidth, $fontName)

    $font = New-Object System.Drawing.Font $fontName, $size, $style, ([System.Drawing.GraphicsUnit]::Pixel)
    $brush = New-Object System.Drawing.SolidBrush $color
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Trimming = [System.Drawing.StringTrimming]::Word
    $rect = New-Object System.Drawing.RectangleF $x, $y, $maxWidth, 3000
    $g.DrawString($text, $font, $brush, $rect, $fmt)
    $h = [int]($g.MeasureString($text, $font, [int]$maxWidth, $fmt).Height)
    $font.Dispose(); $brush.Dispose(); $fmt.Dispose()
    return $h
}

function Add-Badge {
    param($g, $text, $x, $y, $fontName)

    $font = New-Object System.Drawing.Font $fontName, 22, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
    $sz = $g.MeasureString($text, $font)
    $pad = 22
    $w = [int]$sz.Width + 2 * $pad
    $h = 54
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = 27
    $path.AddArc($x, $y, $r, $r, 180, 90)
    $path.AddArc($x + $w - $r, $y, $r, $r, 270, 90)
    $path.AddArc($x + $w - $r, $y + $h - $r, $r, $r, 0, 90)
    $path.AddArc($x, $y + $h - $r, $r, $r, 90, 90)
    $path.CloseFigure()
    $fill = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 103, 80, 164))
    $g.FillPath($fill, $path)
    $fill.Dispose(); $path.Dispose()

    $tb = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($text, $font, $tb, (New-Object System.Drawing.RectangleF $x, $y, $w, $h), $fmt)
    $font.Dispose(); $tb.Dispose(); $fmt.Dispose()
}

function New-Shot {
    param($file, $srcFile, $step, $title, $subtitle, $bullets, $fontName)

    $pair = New-Canvas
    $bmp = $pair[0]; $g = $pair[1]

    $textX = 140
    $textW = 820
    $dark = [System.Drawing.Color]::FromArgb(255, 22, 31, 55)
    $mid = [System.Drawing.Color]::FromArgb(255, 76, 90, 118)
    $accent = [System.Drawing.Color]::FromArgb(255, 103, 80, 164)

    Add-Badge $g $step $textX 196 $fontName

    $y = 300
    $th = Add-Text $g $title $textX $y 62 ([System.Drawing.FontStyle]::Bold) $dark $textW $fontName
    $y = $y + $th + 18
    $sh = Add-Text $g $subtitle $textX $y 29 ([System.Drawing.FontStyle]::Regular) $mid $textW $fontName
    $y = $y + $sh + 52

    foreach ($b in $bullets) {
        $db = New-Object System.Drawing.SolidBrush $accent
        $g.FillEllipse($db, $textX, ($y + 13), 11, 11)
        $db.Dispose()
        $bh = Add-Text $g $b ($textX + 30) $y 26 ([System.Drawing.FontStyle]::Regular) $mid ($textW - 30) $fontName
        $y = $y + $bh + 26
    }

    $winH = 880
    $im = [System.Drawing.Image]::FromFile((Join-Path $src $srcFile))
    $winW = [int]($winH * $im.Width / $im.Height)
    $im.Dispose()
    Add-Window $g (Join-Path $src $srcFile) (1730 - $winW) 100 $winW $winH

    $g.Dispose()
    $bmp.Save((Join-Path $out $file), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "wrote $file"
}

New-Shot "en-01-connect.png" "en-connect.png" "STEP 1" `
    "Plug in your phone" `
    "AudioShare finds it automatically over USB or Wi-Fi." `
    @("No app to install on the phone", "No root, no account, no ads", "Works with Android 6.0 and later") `
    "Segoe UI"

New-Shot "en-02-playing.png" "en-disconnect.png" "STEP 2" `
    "Press Connect" `
    "Everything playing on your PC now comes out of the phone." `
    @("Stereo system audio capture", "Reconnects to the last device", "Nothing is recorded or uploaded") `
    "Segoe UI"

New-Shot "zh-01-connect.png" "zh-connect.png" "第 1 步" `
    "插上安卓手机" `
    "AudioShare 会通过 USB 或 Wi-Fi 自动找到它。" `
    @("手机端无需安装任何应用", "不需要 root、账号或广告", "支持 Android 6.0 及以上") `
    "Microsoft YaHei"

New-Shot "zh-02-playing.png" "zh-disconnect.png" "第 2 步" `
    "点一下连接" `
    "电脑上正在播放的一切，现在都从手机里放出来。" `
    @("立体声捕获系统音频", "自动重连上次使用的设备", "不录制、不上传任何内容") `
    "Microsoft YaHei"
