function git
    set -l requires_cloudflare_access false

    # Check direct URLs and configured remote names for the protected host.
    for argument in $argv
        if string match -qr '^https://git[.]032067[.]xyz(?:/|$)' -- "$argument"
            set requires_cloudflare_access true
            break
        end

        set -l remote_urls \
            (command git remote get-url --all "$argument" 2>/dev/null) \
            (command git remote get-url --push --all "$argument" 2>/dev/null)

        for remote_url in $remote_urls
            if string match -qr '^https://git[.]032067[.]xyz(?:/|$)' -- "$remote_url"
                set requires_cloudflare_access true
                break
            end
        end
    end

    if test "$requires_cloudflare_access" = true
        # Retrieve the service token, prompting to unlock Bitwarden if needed.
        set -l cloudflare_secret (bw_secret Cloudflare service_secret)
        or return

        test -n "$cloudflare_secret"
        or return 1

        # Add the secret header only to requests for the protected host.
        set -fx GIT_CONFIG_COUNT 1
        set -fx GIT_CONFIG_KEY_0 'http.https://git.032067.xyz/.extraHeader'
        set -fx GIT_CONFIG_VALUE_0 "CF-Access-Client-Secret: $cloudflare_secret"
    end

    command git $argv
end
