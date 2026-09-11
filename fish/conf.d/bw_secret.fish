function bw_secret --description "Fetch Cloudflare Client Secret from Bitwarden"
    if test (count $argv) -lt 2
        echo "Usage: get_bw_field <item_name> <field_name>" >&2
        return 1
    end

    if not type -q jq
        echo "Error: 'jq' is required but not installed." >&2
        return 1
    end

    if not type -q bw
        echo "Error: Bitwarden CLI 'bw' is required but not installed." >&2
        return 1
    end

    if not set -q BW_SESSION; or test -z "$BW_SESSION"
        set -gx BW_SESSION (bw unlock --raw)
        # If user cancels or types wrong password, exit cleanly
        if test $status -ne 0; or test -z "$BW_SESSION"
            echo "Error: Failed to unlock Bitwarden vault." >&2
            return 1
        end
    end

    set -l item_name $argv[1]
    set -l field_name $argv[2]

    set -l secret (bw get item "$item_name" 2>/dev/null | jq -r --arg field "$field_name" '.fields[] | select(.name==$field) | .value')

    if test -n "$secret"; and test "$secret" != "null"
        echo $secret
    else
        echo "Error: Could not find custom field 'cf_secret' in 'Cloudflare Git Access'." >&2
        return 1
    end
end
