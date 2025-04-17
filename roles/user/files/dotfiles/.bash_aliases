alias cdtemp='cd $(mktemp -d)'
alias lsblk-e7='lsblk -e7'
alias git-cdup='cd "$(git rev-parse --show-cdup)"'
alias check-connectivity='httping -sGblY -c3 -t5 https://www.google.com/; curl -s https://ipinfo.io/json | jq .; tracepath -b -4 -m5 google.com'
alias rg-no-messages='rg --no-messages'
alias xclips='xclip -selection clip'
alias xclips-indent='xclips -o | sed -e "s/^/    /" | xclips'
alias xclips-blockquote='xclips -o | sed -e "s/^/> /" | xclips'
alias xclips-fold='xclips -o | fold -sw 72 | xclips'
alias xclips-fmt='xclips -o | fmt | xclips'
alias xclips-trim-spaces='xclips -o | sed -e "s/ \+$//" | xclips'
alias pwgenp='pwgen -sB 20 | xclips'
alias pwgenp-nocaps='pwgen -sBA 20 | xclips'
alias encmount-canonical='encfs -o allow_root --idle=720 ~/Dropbox/Canonical/ ~/Canonical/ && cd ~/Canonical/'
alias encmount-private='encfs --idle=60 ~/Dropbox/private/ ~/Documents/private/ && cd ~/Documents/private/'
alias proxy-ctail='lxc exec -t squid-deb-proxy -- tail -F /var/log/squid-deb-proxy/access.log | ccze -AC'
alias vpn-canonical='(cd ~/.sesame/; sed -e "s|/scripts/|/|" /usr/share/doc/openvpn-systemd-resolved/update-systemd-resolved.conf | sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto.conf --config /dev/stdin)'
alias vpn-canonical-global='(cd ~/.sesame/; sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto-global.conf)'
alias vpn-canonical-tcp443='(cd ~/.sesame/; sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto-tcp443.conf)'
alias vpn-canonical-tcp443-global='(cd ~/.sesame/; sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto-tcp443-global.conf)'
alias juju-local-bootstrap='juju bootstrap --model-default apt-http-proxy="http://squid-deb-proxy.lxd:8000/" localhost localhost'
alias juju-aws-bootstrap='juju bootstrap aws/ap-northeast-1'
alias watch-juju-status='watch -c juju status --color'
alias kubectl-wait-deployment='kubectl wait deployment --all --for condition=Available=True --timeout=1h'
alias wakeonlan-darkbox='wakeonlan 70:85:c2:ae:bc:08 c0:06:c3:a1:23:e2'
alias code-use-tox='test ! -e .vscode/ && (mkdir -p $_; echo "{\"python.defaultInterpreterPath\":\".tox/py3/bin/python3\"}" > $_/settings.json) || printf "%s already exists\n" "$_"'
alias v4l2-ctl-zoom='v4l2-ctl --device /dev/video4 -c zoom_absolute=105'
alias v4l2-ctl-zoom-reset='v4l2-ctl --device /dev/video4 -c zoom_absolute=100'
alias sudo-apt-always-include='sudo apt -o APT::Get::Always-Include-Phased-Updates=true'
alias usbreset-synaptics-fp-reader='sudo usbreset 06cb:00f9'
git-clone-openstack() { git clone "https://opendev.org/openstack/$1.git" && cd "$1"; }
ddc-brightness() { ddcutil --display 1 setvcp 10 "$1"; }
ddc-volume() { ddcutil --display 1 setvcp 62 "$1"; }
ddc-mute() { ddcutil --display 1 setvcp 8d "$1"; }
spd-say-stdin() { cat - | fmt -u -w 2500 | sed -e 's/  /\n\n/g' | spd-say -e -w; }
spd-pdf() { pdftotext "$1" - | fmt -u -w 2500 | sed -e 's/  /\n/g' | spd-say -e -w; }
until-then() { until "$@"; do sleep 1; done; }
ght-graders() { cat ~/ght-graders.yml | yq -r ".\"$1\".\"Written Interview\"[] | select(.active==true).name" | sort -R | head -2; }
