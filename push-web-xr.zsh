#!/bin/zsh
# Script otomatis setup SSH + Git LFS + push WebAR repo

# 1️⃣ Cek SSH key
echo "Cek SSH key..."
if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "SSH key sudah ada:"
    cat ~/.ssh/id_ed25519.pub
else
    echo "SSH key tidak ada, membuat baru..."
    ssh-keygen -t ed25519 -C "sjoegamal@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    echo "SSH key dibuat:"
    cat ~/.ssh/id_ed25519.pub
fi

# 2️⃣ Start ssh-agent & add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "SSH key ditambahkan ke ssh-agent"

# 3️⃣ Reminder: tambahkan key ke GitHub
echo "SALIN public key di atas dan tambahkan ke GitHub → Settings → SSH and GPG keys → New SSH key"
read "done? Tekan Enter setelah menambahkan key ke GitHub"

# 4️⃣ Set remote SSH (ganti USERNAME & REPO)
echo "Set remote SSH..."
git remote set-url origin git@github.com:sjoegama/webXr.git

# 5️⃣ Install Git LFS binary (jika belum)
if ! command -v git-lfs &> /dev/null; then
    echo "Git LFS tidak ditemukan. Pastikan sudah di-install."
    echo "Download dari: https://github.com/git-lfs/git-lfs/releases/tag/v3.0.2"
    exit 1
fi

# 6️⃣ Init Git LFS
git lfs install

# 7️⃣ Track file besar
git lfs track "*.glb"
git lfs track "*.USDZ"
git lfs track "*.mp3"
git add .gitattributes

# 8️⃣ Stage semua perubahan
git add .

# 9️⃣ Commit
git commit -m "Update repo + track LFS files" || echo "Tidak ada perubahan untuk di-commit"

# 🔟 Push via SSH
echo "Push ke GitHub..."
git push origin main

echo "Selesai! Semua file besar sudah di-track via LFS dan di-push."
