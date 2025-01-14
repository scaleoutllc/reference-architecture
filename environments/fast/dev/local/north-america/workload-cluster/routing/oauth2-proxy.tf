resource "helm_release" "oauth2" {
  name      = "oauth2-proxy"
  namespace = "ingress"
  chart     = "oauth2-proxy"
  repository = "https://oauth2-proxy.github.io/manifests"
  depends_on = [helm_release.routing]
  reset_values = true
  values = [<<YAML
    global:
      redis:
        password: "wakawaka"
    config:
      clientID: "41f26211-e826-4319-b72b-e2382b63678b"
      clientSecret: "SET ME"
      configFile: |-
        redirect_url = "https://hello.matt-us.fast.dev.wescaleout.cloud/oauth2/callback"
        oidc_issuer_url = "https://login.microsoftonline.com/1f8e11f4-08fe-495c-9976-c2761413d93c/v2.0"
        oidc_groups_claim = "roles"
        provider = "oidc"
        pass_user_headers = true
        # return authenticated user to nginx
        set_xauthrequest = true
        skip_provider_button = false
        provider_display_name = "Azure AD"
        cookie_domains = ["hello.matt-us.fast.dev.wescaleout.cloud"]
        cookie_expire = "1h"
        cookie_httponly = false
        cookie_secure = true
        email_domains = ["wescaleout.com"]
        errors_to_info_log = true
        show_debug_on_error = true
        # we don't want to proxy anything so pick a non-existent directory
        upstreams = [ "static://200" ]
    redis:
      enabled: true
      architecture: standalone
    sessionStorage:
      # Can be one of the supported session storage cookie|redis
      type: redis
      redis:
        clientType: standalone

YAML
  ]
}