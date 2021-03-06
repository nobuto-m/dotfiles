alias cdtemp='cd $(mktemp -d)'
alias git-cdup='cd "$(git rev-parse --show-cdup)"'
alias check-connectivity='httping -sGblY -c3 -t5 https://www.google.com/; curl -s https://ipinfo.io/ | jq .'
alias xclips='xclip -selection clip'
alias xclips-indent='xclips -o | sed -e "s/^/    /" | xclips'
alias xclips-blockquote='xclips -o | sed -e "s/^/> /" | xclips'
alias xclips-fold='xclips -o | fold -sw 72 | xclips'
alias xclips-trim-spaces='xclips -o | sed -e "s/ \+$//" | xclips'
alias pwgenp='pwgen -sB 20 | xclips'
alias pwgenp-nocaps='pwgen -sBA 20 | xclips'
alias encmount-canonical='encfs -o allow_root --idle=720 ~/Dropbox/Canonical/ ~/Canonical/ && cd ~/Canonical/'
alias encmount-private='encfs --idle=60 ~/Dropbox/private/ ~/Documents/private/ && cd ~/Documents/private/'
alias proxy-ctail='lxc exec -t squid-deb-proxy -- tail -F /var/log/squid-deb-proxy/access.log | ccze -AC'
alias vpn-canonical='sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto.conf'
alias vpn-canonical-global='sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto-global.conf'
alias vpn-canonical-tcp443='sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto-tcp443.conf'
alias vpn-canonical-tcp443-global='sudo openvpn --mute-replay-warnings --config ~/.sesame/us-nobuto-tcp443-global.conf'
alias juju-local-bootstrap='juju bootstrap --model-default apt-http-proxy="http://squid-deb-proxy.lxd:8000/" localhost localhost'
alias juju-aws-bootstrap='juju bootstrap aws/ap-northeast-1'
alias wakeonlan-darkbox='wakeonlan 70:85:c2:ae:bc:08'
alias hugo='/snap/hugo/current/bin/hugo' # https://github.com/gohugoio/hugoDocs/issues/1222
alias code-use-tox='test ! -e .vscode/ && (mkdir -p $_; echo "{\"python.defaultInterpreterPath\":\".tox/py3/bin/python3\"}" > $_/settings.json) || printf "%s already exists\n" "$_"'
git-clone-openstack() { git clone "https://opendev.org/openstack/$1.git"; }
ddc-brightness() { ddcutil --display 1 setvcp 10 "$1"; }
ddc-volume() { ddcutil --display 1 setvcp 62 "$1"; }
ddc-mute() { ddcutil --display 1 setvcp 8d "$1"; }
