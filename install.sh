sudo apt update

sudo apt install clamav clamav-daemon

sudo systemctl stop clamav-freshclam

sudo freshclam

sudo systemctl start clamav-freshclam