vcl 4.0;

import directors;    # load the directors

backend server1 {
    # .host = "a.tile.openstreetmap.org";
    .host = "151.101.194.217";
    .port = "80";
}
backend server2 {
    # .host = "b.tile.openstreetmap.org";
    .host = "151.101.2.217"
    .port = "80";
}
backend server3 {
    # .host = "c.tile.openstreetmap.org";
    .host = "151.101.38.217"
    .port = "80"
}

sub vcl_init {
    new bar = directors.round_robin();
    bar.add_backend(server1);
    bar.add_backend(server2);
    bar.add_backend(server3);
}

sub vcl_backend_response {
    set beresp.ttl = 4w;
}

sub vcl_recv {
    # send all traffic to the bar director:
    set req.backend_hint = bar.backend();
    set req.http.user-agent = "${API_DOMAIN_NAME} 4.0.0 contact contact@openindoor.io";
    set req.http.X-Saved-Origin = req.http.Origin;
    unset req.http.Origin;
}


  
