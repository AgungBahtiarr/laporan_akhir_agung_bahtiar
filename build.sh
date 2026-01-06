#!/bin/bash

# ==========================================
# KONFIGURASI
# ==========================================
# Nama file utama tanpa ekstensi .tex
MAIN="main"

# Kode Warna untuk Terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==========================================
# FUNGSI-FUNGSI
# ==========================================

# 1. Cek Kelengkapan File
check_files() {
    if [ ! -f "$MAIN.tex" ]; then
        echo -e "${RED}❌ Error FATAL: File '$MAIN.tex' tidak ditemukan!${NC}"
        echo "   Pastikan script ini berada di folder yang sama dengan file utama LaTeX."
        exit 1
    fi
}

# 2. Membersihkan File Sampah
clean_files() {
    echo -e "${YELLOW}🧹 Membersihkan file sampah (aux, log, bbl, toc, dll)...${NC}"

    # Gunakan latexmk -C untuk pembersihan standar
    latexmk -C > /dev/null 2>&1

    # Pembersihan manual tambahan untuk file yang sering tertinggal
    rm -f *.bbl *.run.xml *.bcf *.synctex.gz *.toc *.lot *.lof *.out *.fls *.fdb_latexmk *.xdv

    echo -e "${GREEN}✅ Direktori bersih!${NC}"
}

# ==========================================
# MENU UTAMA
# ==========================================
check_files

clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}   TOOLS KOMPILASI SKRIPSI (FEDORA)      ${NC}"
echo -e "${BLUE}==========================================${NC}"
echo "1. 🚀 Clean Build (Hapus cache & Kompilasi Ulang Total)"
echo "   -> Gunakan ini jika error 'undefined citation' atau layout berantakan."
echo ""
echo "2. 👀 Watch Mode (Live Preview)"
echo "   -> Otomatis compile saat file di-save (Ctrl+S)."
echo "   -> Tekan Ctrl+C untuk berhenti."
echo ""
echo "3. 🧹 Clean Only"
echo "   -> Hanya menghapus file sampah tanpa kompilasi."
echo -e "${BLUE}==========================================${NC}"
read -p "Pilih menu [1-3]: " choice

if [ "$choice" == "1" ]; then
    clean_files
    echo -e "${YELLOW}🚀 Memulai kompilasi total (Mungkin agak lama)...${NC}"

    # Compile dengan flag -file-line-error agar lokasi error mudah ditemukan
    latexmk -pdf -file-line-error -interaction=nonstopmode -synctex=1 $MAIN.tex

    # Cek status exit code dari latexmk
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ SUKSES! File PDF siap dibuka: $MAIN.pdf${NC}"
    else
        echo -e "${RED}❌ GAGAL! Ada error pada kodingan LaTeX Anda.${NC}"
        echo -e "${YELLOW}   Silakan scroll ke atas dan cari pesan yang diawali tanda '!' ${NC}"
    fi

elif [ "$choice" == "2" ]; then
    echo -e "${YELLOW}👀 Memulai Watch Mode... (Edit file .tex Anda, lalu Save)${NC}"
    # Mode -pvc (Preview Continuously)
    latexmk -pdf -pvc -file-line-error -interaction=nonstopmode -synctex=1 $MAIN.tex

elif [ "$choice" == "3" ]; then
    clean_files

else
    echo -e "${RED}❌ Pilihan tidak valid.${NC}"
fi
