#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 


show_header() {
    clear
    echo -e "${BLUE}"
    echo "   AUTO LINK SHORTENER"
    echo "   Link Pemendek Otomatis"
    echo -e "${NC}"
    echo "   Mendukung multiple URL shortener services"
    echo ""
}


validate_url() {
    local url="$1"
    if [[ $url =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

shorten_isgd() {
    local long_url="$1"
    local short_url=$(curl -s "https://is.gd/create.php?format=simple&url=${long_url}")
    echo "$short_url"
}


shorten_tinyurl() {
    local long_url="$1"
    local short_url=$(curl -s "http://tinyurl.com/api-create.php?url=${long_url}")
    echo "$short_url"
}


shorten_0x0() {
    local long_url="$1"
    local short_url=$(curl -s -F "url=${long_url}" "https://0x0.st")
    echo "$short_url"
}


shorten_dagd() {
    local long_url="$1"
    local short_url=$(curl -s "https://da.gd/s?url=${long_url}")
    echo "$short_url"
}


shorten_gitio() {
    local long_url="$1"
    local short_url=$(curl -s -i "https://git.io" -F "url=${long_url}" | grep -oP 'Location: \K\S+' | tr -d '\r')
    echo "$short_url"
}


shorten_shorturlat() {
    local long_url="$1"
    local short_url=$(curl -s "https://shorturl.at/api.php?url=${long_url}")
    echo "$short_url"
}


shorten_tinycc() {
    local long_url="$1"
    local short_url=$(curl -s "http://tiny.cc/?c=rest_api&m=shorten&version=2.0.3&format=json&url=${long_url}" | grep -oP '"short_url":"\K[^"]+')
    echo "$short_url"
}


shorten_clckru() {
    local long_url="$1"
    local short_url=$(curl -s "http://clck.ru/--?url=${long_url}")
    echo "$short_url"
}

shorten_cuttly() {
    local long_url="$1"
    local short_url=$(curl -s "https://cutt.ly/scripts/shortenUrl.php?url=${long_url}")
    echo "$short_url"
}


shorten_vgd() {
    local long_url="$1"
    local short_url=$(curl -s "https://v.gd/create.php?format=simple&url=${long_url}")
    echo "$short_url"
}


services=(
    "is.gd"
    "tinyurl"
    "0x0.st"
    "da.gd"
    "git.io"
    "shorturl.at"
    "tiny.cc"
    "clck.ru"
    "cutt.ly"
    "v.gd"
)


try_shorten() {
    local service="$1"
    local url="$2"
    
    case $service in
        "is.gd")
            shorten_isgd "$url"
            ;;
        "tinyurl")
            shorten_tinyurl "$url"
            ;;
        "0x0.st")
            shorten_0x0 "$url"
            ;;
        "da.gd")
            shorten_dagd "$url"
            ;;
        "git.io")
            shorten_gitio "$url"
            ;;
        "shorturl.at")
            shorten_shorturlat "$url"
            ;;
        "tiny.cc")
            shorten_tinycc "$url"
            ;;
        "clck.ru")
            shorten_clckru "$url"
            ;;
        "cutt.ly")
            shorten_cuttly "$url"
            ;;
        "v.gd")
            shorten_vgd "$url"
            ;;
        *)
            echo ""
            ;;
    esac
}


main() {
    show_header
    
   
    echo -e "${YELLOW}Masukan link yang ingin diperpendek:${NC}"
    read -p "   " long_url
    echo ""
    
   
    if ! validate_url "$long_url"; then
        echo -e "${RED}Error: URL tidak valid! Pastikan URL dimulai dengan http:// atau https://${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Memproses link dengan berbagai layanan...${NC}"
    echo ""
    
    
    success=false
    for service in "${services[@]}"; do
        echo -e "${BLUE}Mencoba ${service}:${NC}"
        result=$(try_shorten "$service" "$long_url")
        
        if [ -n "$result" ] && [[ $result == http* ]]; then
            echo -e "${GREEN}   Berhasil: $result${NC}"
            success=true
            break
        else
            echo -e "${YELLOW}   Gagal dengan ${service}, mencoba layanan berikutnya...${NC}"
            sleep 0.5
        fi
    done
    
    if [ "$success" = false ]; then
        echo -e "${RED}   Gagal memendekkan link dengan semua layanan${NC}"
        echo -e "${YELLOW}   Coba lagi nanti atau gunakan layanan lain${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}Selesai!${NC}"
    echo -e "${BLUE}Total layanan yang tersedia: ${#services[@]}${NC}"
}


main