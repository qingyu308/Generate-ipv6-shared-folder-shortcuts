@echo off
:: 设置控制台编码为UTF-8以支持中文显示
chcp 65001 >nul

:: 启用延迟变量扩展
setlocal EnableDelayedExpansion

:: 显示脚本功能说明
echo.
echo 这个脚本用于生成基于IPv6地址的共享文件夹路径，并在桌面上创建一个快捷方式。
echo 请按提示输入IPv6地址，格式示例：2408:8234:912:61b2:e0b2:f85:8213:526e
echo.

:: 提示用户输入IPv6地址
set /p ipv6Address=请输入IPv6地址: 

:: 检查用户输入的IPv6地址
if "%ipv6Address%"=="" (
    echo 没有输入IPv6地址，请重试。
    pause
    exit /b
)

:: 清除无效字符，只保留数字和冒号
set "cleanedIPv6="
for /l %%i in (0,1,39) do (
    set "char=!ipv6Address:~%%i,1!"
    if "!char!"=="" (
        goto endloop
    )
    echo "!char!" | findstr /r "[0-9a-fA-F:]" >nul
    if not errorlevel 1 (
        set "cleanedIPv6=!cleanedIPv6!!char!"
    )
)
:endloop

:: 使用清理后的IPv6地址（如果没有无效字符，则保持原样）
if "!cleanedIPv6!"=="" (
    echo 输入的IPv6地址格式不正确，无法生成路径。
    pause
    exit /b
)

:: 处理后的IPv6地址
set ipv6Address=!cleanedIPv6!

:: 替换IPv6地址中的冒号为连字符
set ipv6Literal=!ipv6Address::=-!

:: 构造共享文件夹路径
set sharePath=\\!ipv6Literal!.ipv6-literal.net

:: 输出结果
echo 已生成共享文件夹路径：!sharePath!

:: 获取当前用户的桌面路径
set desktopPath=%USERPROFILE%\Desktop

:: 创建共享文件夹的快捷方式
echo [InternetShortcut] > "!desktopPath!\共享文件夹.url"
echo URL=!sharePath! >> "!desktopPath!\共享文件夹.url"

echo 快捷方式已创建在桌面: !desktopPath!\共享文件夹.url
pause
