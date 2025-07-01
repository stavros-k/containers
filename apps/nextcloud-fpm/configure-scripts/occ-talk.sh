#!/bin/sh
occ_talk_install() {
  echo '## Configuring Talk...'
  echo ''

  install_app spreed

  # ie "stun1:3478 stun2:3478"
  occ config:app:delete spreed stun_servers
  for stun_server in ${NX_TALK_STUN_SERVERS:?"NX_TALK_STUN_SERVERS is unset"}; do
    occ talk:stun:add "$stun_server"
  done

  # ie "domain,port,secret domain2,port2,secret"
  occ config:app:delete spreed turn_servers
  for turn_server in ${NX_TALK_TURN_SERVERS:?"NX_TALK_TURN_SERVERS is unset"}; do
    host=$(echo "${turn_server}" | cut -d',' -f1)
    host=${host:?"host could not be extracted"}
    port=$(echo "${turn_server}" | cut -d',' -f2)
    port=${port:?"port could not be extracted"}
    secret=$(echo "${turn_server}" | cut -d',' -f3)
    secret=${secret:?"secret could not be extracted"}

    occ talk:turn:add turn "$host:$port" "udp,tcp" --secret="$secret"
  done

  # ie "server,true server2,false"
  occ config:app:delete spreed signaling_servers
  for signaling_server in ${NX_TALK_SIGNALING_SERVERS:?"NX_TALK_SIGNALING_SERVERS is unset"}; do
    server=$(echo "${signaling_server}" | cut -d',' -f1)
    server=${server:?"server could not be extracted"}
    verify=$(echo "${signaling_server}" | cut -d',' -f2)
    verify=${verify:?"verify could not be extracted"}
    if [ "${verify}" = "true" ]; then
      verify="--verify"
    else
      verify=""
    fi

    occ talk:signaling:add "https://$server" "${NX_TALK_SIGNALING_SECRET:?"NX_TALK_SIGNALING_SECRET is unset"}" $verify
  done
}

occ_talk_remove() {
  echo '## Removing Talk Configuration...'
  echo ''

  remove_app spreed
  occ config:app:delete spreed turn_servers
  occ config:app:delete spreed stun_servers
  occ config:app:delete spreed signaling_servers
}
