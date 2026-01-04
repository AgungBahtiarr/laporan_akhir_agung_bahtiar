#!/bin/bash

# Konfigurasi Nama File Utama (Tanpa ekstensi .tex)
MAIN="main"

# Fungsi untuk membersihkan file sampah
clean_files() {
    echo "🧹 Membersihkan file sampah (aux, log, bbl, bcf, dll)..."
    latexmk -C
    # Hapus file spesifik biblatex/biber yang kadang tertinggal
    rm -f *.bbl *.run.xml *.bcf *.synctex.gz *.toc *.lot *.lof
    echo "✅ Bersih!"
}

# Tampilkan Menu
clear
echo "=========================================="
echo "   TOOLS KOMPILASI SKRIPSI (FEDORA) "
echo "=========================================="
echo "1. 🚀 Clean Build (Hapus cache & Kompilasi ulang total)"
echo "   -> Gunakan ini jika ada error aneh atau update daftar pustaka."
echo ""
echo "2. 👀 Watch Mode (Live Preview)"
echo "   -> Otomatis kompilasi setiap kali file di-save."
echo "   -> Cocok saat sedang menulis."
echo ""
echo "3. 🧹 Clean Only"
echo "   -> Hanya menghapus file sampah."
echo "=========================================="
read -p "Pilih menu [1-3]: " choice

if [ "$choice" == "1" ]; then
    clean_files
    echo "🚀 Memulai kompilasi total..."
    # -synctex=1 agar bisa klik di PDF kembali ke kodingan
    latexmk -pdf -interaction=nonstopmode -synctex=1 $MAIN.tex
    echo "✅ Selesai! Cek file $MAIN.pdf"

elif [ "$choice" == "2" ]; then
    echo "👀 Memulai Watch Mode (Tekan Ctrl+C untuk berhenti)..."
    # -pvc = Preview Continuously
    latexmk -pdf -pvc -interaction=nonstopmode -synctex=1 $MAIN.tex

elif [ "$choice" == "3" ]; then
    clean_files

else
    echo "❌ Pilihan tidak valid."
fi
