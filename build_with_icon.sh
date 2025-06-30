#!/bin/bash

echo "🧹 Limpando build cache..."
flutter clean

echo "📦 Baixando dependências..."
flutter pub get

echo "🎨 Configurando ícone personalizado..."
dart run flutter_launcher_icons

echo "🔧 Construindo para release..."
flutter build macos --release --no-tree-shake-icons

echo "✅ Build concluído! Seu app agora tem o ícone personalizado do TicTask."
echo ""
echo "📍 O app está em: build/macos/Build/Products/Release/tictask.app"
echo ""
echo "Para outras plataformas:"
echo "- Android: flutter build apk --release"
echo "- iOS: flutter build ios --release"
echo "- Windows: flutter build windows --release"
echo "- Linux: flutter build linux --release"
