# Deployment Notes

## TURN server for Internet Transfer

Beware that you have to host your own TURN server to enable transfers between different networks.

Follow [this guide](https://gabrieltanner.org/blog/turn-server/) to either install coturn directly on your system (Step 1).
 
Alternatively, use a free, pre-configured TURN server like [OpenRelay](https://www.metered.ca/tools/openrelay/)

<br>

## CLIP via HTTPS

On some browsers CLIP must be served over TLS in order for some features to work properly.
These may include:
- Copying an incoming message via the 'copy' button
- Installing CLIP as PWA
- Persistent pairing of devices
- Changing of the display name
- Notifications

Naturally, this is also recommended to increase security.

#### Port

```bash
-p 127.0.0.1:8080:3000
```

## Deployment with Node.js

Clone this repository and enter the folder

```bash
git clone https://github.com/personalmedia/clip.git && cd clip
```

Install all dependencies with NPM:

```bash
npm install
```

Start the server with:

```bash
npm start
```

> By default, the node server listens on port 3000.


<br>

### Options / Flags

These are some flags only reasonable when deploying via Node.js

#### Port

```bash
PORT=3000
```

> Default: `3000`
> 
> Environment variable to specify the port used by the Node.js server \
> e.g. `PORT=3010 npm start`

#### Local Run

```bash
npm start -- --localhost-only
```

> Only allow connections from localhost.
>
> You must use a server proxy to set the `X-Forwarded-For` header 
> to prevent all clients from discovering each other (See [#HTTP-Server](#http-server)).
>
> Use this when deploying CLIP with node to prevent 
> bypassing the reverse proxy by reaching the Node.js server directly.

#### Automatic restart on error

```bash
npm start -- --auto-restart
```

> Restarts server automatically on error

#### Production (autostart and rate-limit)

```bash
npm run start:prod
```

> shortcut for `RATE_LIMIT=5 npm start -- --auto-restart`

#### Production (autostart, rate-limit, localhost-only)

```bash
npm run start:prod -- --localhost-only
```

> To prevent connections to the node server from bypassing \
> the proxy server you should always use "--localhost-only" on production.

#### Set Environment Variables via Node.js

To specify environment variables set them in the run command in front of `npm start`.
The syntax is different on Unix and Windows.

On Unix based systems

```bash
PORT=3000 RTC_CONFIG="rtc_config.json" npm start
```

On Windows

```bash
$env:PORT=3000 RTC_CONFIG="rtc_config.json"; npm start
```

Overview of available Environment Variables are found [here](#environment-variables).

<br>

## Environment Variables

### Debug Mode

```bash
DEBUG_MODE="true"
```

> Default: `false`
>
> Logs the used environment variables for debugging.
>
> Prints debugging information about the connecting peers IP addresses.
> 
> This is quite useful to check whether the [#HTTP-Server](#http-server)
> is configured correctly, so the auto-discovery feature works correctly.
> Otherwise, all clients discover each other mutually, independently of their network status.
>
> If this flag is set to `"true"` each peer that connects to the CLIP server will produce a log to STDOUT like this:
>
> ```
> ----DEBUGGING-PEER-IP-START----
> remoteAddress: ::ffff:172.17.0.1
> x-forwarded-for: 19.117.63.126
> cf-connecting-ip: undefined
> CLIP uses: 19.117.63.126
> IP is private: false
> if IP is private, '127.0.0.1' is used instead
> ----DEBUGGING-PEER-IP-END----
> ```
>
> If the IP address "CLIP uses" matches the public IP address of the client device, everything is set up correctly. \
> To find out the public IP address of the client device visit https://whatsmyip.com/.
>
> To preserve your clients' privacy: \
> **Never use this environment variable in production!**


<br>

### Rate limiting requests

```bash
RATE_LIMIT=1
```

> Default: `false`
>
> Limits clients to 1000 requests per 5 min
>
> "If you are behind a proxy/load balancer (usually the case with most hosting services, e.g. Heroku, Bluemix, AWS ELB,
> Render, Nginx, Cloudflare, Akamai, Fastly, Firebase Hosting, Rackspace LB, Riverbed Stingray, etc.), the IP address of
> the request might be the IP of the load balancer/reverse proxy (making the rate limiter effectively a global one and
> blocking all requests once the limit is reached) or undefined."
> (See: https://express-rate-limit.mintlify.app/guides/troubleshooting-proxy-issues)
>
> To find the correct number to use for this setting:
>
> 1. Start CLIP with `DEBUG_MODE=True` and `RATE_LIMIT=1`
> 2. Make a `get` request to `/ip` of the CLIP instance (e.g. `https://clip-example.net/ip`)
> 3. Check if the IP address returned in the response matches your public IP address (find out by visiting e.g. https://whatsmyip.com/)
> 4. You have found the correct number if the IP addresses match. If not, then increase `RATE_LIMIT` by one and redo 1. - 4.
>
> e.g. on Render you must use RATE_LIMIT=5


<br>

### IPv6 Localization

```bash
IPV6_LOCALIZE=4
```

> Default: `false`
>
> To enable Peer Auto-Discovery among IPv6 peers, you can specify a reduced number of segments \
> of the client IPv6 address to be evaluated as the peer's IP. \
> This can be especially useful when using Cloudflare as a proxy.
>
> The flag must be set to an **integer** between `1` and `7`. \
> The number represents the number of IPv6 [hextets](https://en.wikipedia.org/wiki/IPv6#Address_representation) \
> to match the client IP against. The most common value would be `4`, \
> which will group peers within the same `/64` subnet.


<br>

### Websocket Fallback (for VPN)

```bash
WS_FALLBACK=true
```

> Default: `false`
>
> Provides CLIP to clients with an included websocket fallback \
> if the peer to peer WebRTC connection is not available to the client.
>
> This is not used on the official https://clip.pm website, 
> but you can activate it on your self-hosted instance.\
> This is especially useful if you connect to your instance via a VPN (as most VPN services block WebRTC completely in 
> order to hide your real IP address). ([Read more here](https://privacysavvy.com/security/safe-browsing/disable-webrtc-chrome-firefox-safari-opera-edge/)).
>
> **Warning:** \
> All traffic sent between devices using this fallback
> is routed through the server and therefor not peer to peer!
> 
> Beware that the traffic routed via this fallback is readable by the server. \
> Only ever use this on instances you can trust.
> 
> Additionally, beware that all traffic using this fallback debits the servers data plan.


<br>

### Specify STUN/TURN Servers

```bash
RTC_CONFIG="rtc_config.json"
```

> Default: `false`
>
> Specify the STUN/TURN servers CLIP clients use by setting \
> `RTC_CONFIG` to a JSON file including the configuration. \
> You can use `rtc_config_example.json` as a starting point.
>
> To host your own TURN server you can follow this guide: https://gabrieltanner.org/blog/turn-server/
> Alternatively, use a free, pre-configured TURN server like [OpenRelay](<[url](https://www.metered.ca/tools/openrelay/)>)
>
> Default configuration:
>
> ```json
> {
>   "sdpSemantics": "unified-plan",
>   "iceServers": [
>     {
>       "urls": "stun:stun.l.google.com:19302"
>     }
>   ]
> }
> ```

<br>

You can host an instance that uses another signaling server
This can be useful if you don't want to trust the client files that are hosted on another instance but still want to connect to devices that use https://clip.pm.

### Specify Signaling Server

```bash
SIGNALING_SERVER="clip.pm"
```

> Default: `false`
>
> By default, clients connecting to your instance use the signaling server of your instance to connect to other devices.
> 
> By using `SIGNALING_SERVER`, you can host an instance that uses another signaling server.
> 
> This can be useful if you want to ensure the integrity of the client files and don't want to trust the client files that are hosted on another CLIP instance but still want to connect to devices that use the other instance.
> E.g. host your own client files under *clip.your-domain.com* but use the official signaling server under *clip.pm*
> This way devices connecting to *clip.your-domain.com* and *clip.pm* can discover each other.
> 
> Beware that the version of your CLIP server must be compatible with the version of the signaling server.
>
> `SIGNALING_SERVER` must be a valid url without the protocol prefix. 
> Examples of valid values: `clip.pm`, `clip.your-domain.com:3000`, `your-domain.com/clip`

<br>

### Customizable buttons for the _About CLIP_ page

```bash
DONATION_BUTTON_ACTIVE=true
DONATION_BUTTON_LINK="https://www.buymeacoffee.com/clip"
DONATION_BUTTON_TITLE="Buy me a coffee"
TWITTER_BUTTON_ACTIVE=true
TWITTER_BUTTON_LINK="https://twitter.com/account"
TWITTER_BUTTON_TITLE="Find me on Twitter"
MASTODON_BUTTON_ACTIVE=true
MASTODON_BUTTON_LINK="https://mastodon.social/account"
MASTODON_BUTTON_TITLE="Find me on Mastodon"
BLUESKY_BUTTON_ACTIVE=true
BLUESKY_BUTTON_LINK="https://bsky.app/profile/account"
BLUESKY_BUTTON_TITLE="Find me on Bluesky"
CUSTOM_BUTTON_ACTIVE=true
CUSTOM_BUTTON_LINK="https://your-custom-social-network.net/account"
CUSTOM_BUTTON_TITLE="Find me on this custom social network"
PRIVACYPOLICY_BUTTON_ACTIVE=true
PRIVACYPOLICY_BUTTON_LINK="https://link-to-your-privacy-policy.net"
PRIVACYPOLICY_BUTTON_TITLE="Open our privacy policy"
```

> Default: unset
>
> By default, clients will show the default button configuration: GitHub, BuyMeACoffee, Twitter, and FAQ on GitHub.
> 
> The GitHub and FAQ on GitHub buttons are essential, so they are always shown.
> 
> The other buttons can be customized:
>
> * `*_BUTTON_ACTIVE`: set this to `true` to show a natively hidden button or to `false` to hide a normally shown button
> * `*_BUTTON_LINK`: set this to any URL to overwrite the href attribute of the button
> * `*_BUTTON_TITLE`: set this to overwrite the hover title of the button. This will prevent the title from being translated.

<br>

<br>

## HTTP-Server

When running CLIP, the `X-Forwarded-For` header has to be set by a proxy. \
Otherwise, all clients will be mutually visible.

To check if your setup is configured correctly [use the environment variable `DEBUG_MODE="true"`](#debug-mode).

### Using nginx

#### Allow http and https requests

```
server {
    listen       80;

    expires epoch;

    location / {
        proxy_connect_timeout 300;
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Connection "upgrade";
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Forwarded-for $remote_addr;
    }
}

server {
    listen       443 ssl http2;
    ssl_certificate /etc/ssl/certs/clip-dev.crt;
    ssl_certificate_key /etc/ssl/certs/clip-dev.key;

    expires epoch;

    location / {
        proxy_connect_timeout 300;
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Connection "upgrade";
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Forwarded-for $remote_addr;
    }
}
```

#### Automatic http to https redirect:

```
server {
    listen       80;

    expires epoch;

    location / {
        return 301 https://$host:3000$request_uri;
    }
}

server {
    listen       443 ssl http2;
    ssl_certificate /etc/ssl/certs/clip-dev.crt;
    ssl_certificate_key /etc/ssl/certs/clip-dev.key;

    expires epoch;

    location / {
        proxy_connect_timeout 300;
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Connection "upgrade";
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Forwarded-for $remote_addr;
    }
}
```


<br>

### Using Apache

install modules `proxy`, `proxy_http`, `mod_proxy_wstunnel`

```bash
a2enmod proxy
```

```bash
a2enmod proxy_http
```

<br>

Create a new configuration file under `/etc/apache2/sites-available` (on Debian)

**clip.conf**

#### Allow HTTP and HTTPS requests

```apacheconf
<VirtualHost *:80>
	ProxyPass / http://127.0.0.1:3000/ upgrade=websocket
</VirtualHost>
<VirtualHost *:443>
	ProxyPass / https://127.0.0.1:3000/ upgrade=websocket
</VirtualHost>
```

#### Automatic HTTP to HTTPS redirect:

```apacheconf
<VirtualHost *:80>
	Redirect permanent / https://127.0.0.1:3000/
</VirtualHost>
<VirtualHost *:443>
	ProxyPass / http://127.0.0.1:3000/ upgrade=websocket
</VirtualHost>
```

Activate the new virtual host and reload Apache:

```bash
a2ensite clip
```

```bash
service apache2 reload
```

<br>

### Firewall
To run CLIP including its own coturn-server you need to punch holes in the firewall. These ports must be opened additionally:
- 3478 tcp/udp
- 5349 tcp/udp
- 10000:20000 tcp/udp

<br>

## Local Development

### Install

All files needed for developing are available in the folder `./dev`.

<br>

#### Testing PWA related features

PWAs requires the app to be served under a correctly set up and trusted TLS endpoint.

##### Chrome
- When using Chrome, you need to restart Chrome so it reloads the trust store (`chrome://restart`).

##### Google Chrome
- To skip the installation of the certificate, you can also open `chrome://flags/#unsafely-treat-insecure-origin-as-secure`
- The feature `Insecure origins treated as secure` must be enabled and the list must include your CLIP test instance. E.g.: `http://127.0.0.1:3000,https://127.0.0.1:8443`

Please note that the certificates (CA and webserver cert) expire after a day.

The site is served on `https://<Your FQDN>:8443` (Default: `https://localhost:8443`).

[< Back](/README.md)
