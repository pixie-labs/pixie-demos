
package envoy.authz

import rego.v1


import data.px.service.backend


authz_by_service := {
        "backend": data.px.service.backend.valid_sources
}

default allow := false

dest_source_spiffe_ids := dest_source_spiffe_svc if {
    [by, _, uri_type_san] := split(input.attributes.request.http.headers["x-forwarded-client-cert"], ";")
    [_, source_spiffe_id] := split(uri_type_san, "=")
    source_spiffe_parts := split(source_spiffe_id, "/")
    source_spiffe_svc := source_spiffe_parts[count(source_spiffe_parts) - 1]

    [_, dest_spiffe_id] := split(by, "=")
    dest_spiffe_parts := split(dest_spiffe_id, "/")
    dest_spiffe_svc := dest_spiffe_parts[count(dest_spiffe_parts) - 1]

    dest_source_spiffe_svc := [dest_spiffe_svc, source_spiffe_svc]
}

check_l7_access(allowed_access, path, method) if {
    some path_method_pair in allowed_access
    path_method_pair.method == method
    startswith(path, path_method_pair.prefix)
}

dest_svc := dest_source_spiffe_ids[0]

source_svc := dest_source_spiffe_ids[1]

allowed_sources := object.get(authz_by_service, dest_svc, {})

path := input.attributes.request.http.path

method := input.attributes.request.http.method

allow if {
    some dest, sources in authz_by_service
    dest == dest_svc

    some src, _ in sources
    src == source_svc
    check_l7_access(object.get(allowed_sources, source_svc, {}), path, method)
}