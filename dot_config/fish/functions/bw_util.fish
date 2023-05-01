#!/usr/bin/env fish
function unlock_bw_if_locked
    if test -z $BW_SESSION
        echo 'bw locked - unlocking into a new session'
        bw login 
        set -gx BW_SESSION "$(bw unlock --raw)"
    end
end

function add_key
  unlock_bw_if_locked
  set -l bw_ssh_dir $(bw list folders --search ssh | jq -r '.[0].id')
  for f in $argv
      if test -e $f
          set -l fn $(basename $f)
          echo $BW_SESSION
          echo "{\"organizationId\":null,\"folderId\":\"$bw_ssh_dir\",\"type\":2,\"name\":\"$fn\",\"notes\":\"$(sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\\\n/g' $f)\",\"favorite\":false,\"fields\":[],\"login\":null,\"secureNote\":{\"type\":0},\"card\":null,\"identity\":null}" | bw encode | bw create item
      end
  end
end

function get_key
  unlock_bw_if_locked
  set -l bw_item_id $(bw list items --search $argv | jq -r '.[0].id')
  set -l bw_key $(bw get notes $bw_item_id)
  echo $bw_key > ~/.ssh/$argv
  chmod 0600 ~/.ssh/$argv

end

get_key $argv

