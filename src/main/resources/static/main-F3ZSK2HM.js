import {
  $ as N,
  $a as bi,
  A as un,
  Aa as or,
  Ab as vn,
  B as vt,
  Ba as rr,
  Bb as xt,
  C as Wo,
  Ca as ar,
  Cb as br,
  D as Ko,
  Da as sr,
  Db as gr,
  E as Ht,
  Ea as cr,
  Eb as T,
  F as Rt,
  Fa as dr,
  Fb as Kt,
  G as hn,
  Ga as nt,
  Gb as vr,
  H as Zo,
  Ha as Te,
  Hb as _n,
  I as Qo,
  Ia as L,
  Ib as yn,
  J as Yo,
  Ja as k,
  Jb as _r,
  K as ci,
  Ka as Se,
  Kb as yr,
  L as di,
  La as lr,
  Lb as S,
  M as _t,
  Ma as mi,
  Mb as wi,
  N as ne,
  Na as pi,
  Nb as xn,
  O as R,
  Oa as ur,
  Ob as wn,
  P as M,
  Pa as Re,
  Pb as xr,
  Q as oe,
  Qa as Fe,
  Qb as wr,
  R as _,
  Ra as ot,
  Rb as Ne,
  S as O,
  Sa as hr,
  Sb as kr,
  T as Xo,
  Ta as mr,
  U as C,
  Ua as pn,
  V as mn,
  Va as fi,
  W as f,
  Wa as A,
  X as h,
  Xa as Y,
  Y as Ie,
  Ya as J,
  Z as w,
  Za as q,
  _ as P,
  _a as wt,
  a as u,
  aa as mt,
  ab as pr,
  b as U,
  ba as Gt,
  bb as fn,
  c as Bo,
  ca as Jo,
  cb as bn,
  d as ke,
  da as Ee,
  db as v,
  e as $o,
  ea as Ft,
  eb as g,
  f as an,
  fa as re,
  fb as F,
  g as sn,
  ga as H,
  gb as Nt,
  h as cn,
  ha as G,
  hb as gi,
  i as lt,
  ia as De,
  ib as W,
  j as X,
  ja as li,
  jb as Pt,
  k as Tt,
  ka as Ae,
  kb as pt,
  l as ut,
  la as Ot,
  lb as tt,
  m as b,
  ma as tr,
  mb as vi,
  n as Bt,
  na as qt,
  nb as yt,
  o as Ho,
  oa as V,
  ob as rt,
  p as Go,
  pa as Q,
  pb as at,
  q as x,
  qa as er,
  qb as _i,
  r as Ce,
  ra as ui,
  rb as D,
  s as ht,
  sa as ir,
  sb as ce,
  t as si,
  ta as Et,
  tb as Wt,
  u as dn,
  ua as it,
  ub as j,
  v as qo,
  va as Me,
  vb as yi,
  w as It,
  wa as hi,
  wb as gn,
  x as St,
  xa as ae,
  xb as xi,
  y as $t,
  ya as se,
  yb as Oe,
  z as ln,
  za as nr,
  zb as fr,
} from './chunk-5CMZKWTK.js';
var Cn = class {};
var Zt = class i {
  constructor(t) {
    (this.normalizedNames = new Map()),
      (this.lazyUpdate = null),
      t
        ? typeof t == 'string'
          ? (this.lazyInit = () => {
              (this.headers = new Map()),
                t
                  .split(
                    `
`
                  )
                  .forEach((o) => {
                    let e = o.indexOf(':');
                    if (e > 0) {
                      let n = o.slice(0, e),
                        r = n.toLowerCase(),
                        a = o.slice(e + 1).trim();
                      this.maybeSetNormalizedName(n, r),
                        this.headers.has(r)
                          ? this.headers.get(r).push(a)
                          : this.headers.set(r, [a]);
                    }
                  });
            })
          : typeof Headers < 'u' && t instanceof Headers
            ? ((this.headers = new Map()),
              t.forEach((o, e) => {
                this.setHeaderEntries(e, o);
              }))
            : (this.lazyInit = () => {
                (this.headers = new Map()),
                  Object.entries(t).forEach(([o, e]) => {
                    this.setHeaderEntries(o, e);
                  });
              })
        : (this.headers = new Map());
  }
  has(t) {
    return this.init(), this.headers.has(t.toLowerCase());
  }
  get(t) {
    this.init();
    let o = this.headers.get(t.toLowerCase());
    return o && o.length > 0 ? o[0] : null;
  }
  keys() {
    return this.init(), Array.from(this.normalizedNames.values());
  }
  getAll(t) {
    return this.init(), this.headers.get(t.toLowerCase()) || null;
  }
  append(t, o) {
    return this.clone({ name: t, value: o, op: 'a' });
  }
  set(t, o) {
    return this.clone({ name: t, value: o, op: 's' });
  }
  delete(t, o) {
    return this.clone({ name: t, value: o, op: 'd' });
  }
  maybeSetNormalizedName(t, o) {
    this.normalizedNames.has(o) || this.normalizedNames.set(o, t);
  }
  init() {
    this.lazyInit &&
      (this.lazyInit instanceof i
        ? this.copyFrom(this.lazyInit)
        : this.lazyInit(),
      (this.lazyInit = null),
      this.lazyUpdate &&
        (this.lazyUpdate.forEach((t) => this.applyUpdate(t)),
        (this.lazyUpdate = null)));
  }
  copyFrom(t) {
    t.init(),
      Array.from(t.headers.keys()).forEach((o) => {
        this.headers.set(o, t.headers.get(o)),
          this.normalizedNames.set(o, t.normalizedNames.get(o));
      });
  }
  clone(t) {
    let o = new i();
    return (
      (o.lazyInit =
        this.lazyInit && this.lazyInit instanceof i ? this.lazyInit : this),
      (o.lazyUpdate = (this.lazyUpdate || []).concat([t])),
      o
    );
  }
  applyUpdate(t) {
    let o = t.name.toLowerCase();
    switch (t.op) {
      case 'a':
      case 's':
        let e = t.value;
        if ((typeof e == 'string' && (e = [e]), e.length === 0)) return;
        this.maybeSetNormalizedName(t.name, o);
        let n = (t.op === 'a' ? this.headers.get(o) : void 0) || [];
        n.push(...e), this.headers.set(o, n);
        break;
      case 'd':
        let r = t.value;
        if (!r) this.headers.delete(o), this.normalizedNames.delete(o);
        else {
          let a = this.headers.get(o);
          if (!a) return;
          (a = a.filter((s) => r.indexOf(s) === -1)),
            a.length === 0
              ? (this.headers.delete(o), this.normalizedNames.delete(o))
              : this.headers.set(o, a);
        }
        break;
    }
  }
  setHeaderEntries(t, o) {
    let e = (Array.isArray(o) ? o : [o]).map((r) => r.toString()),
      n = t.toLowerCase();
    this.headers.set(n, e), this.maybeSetNormalizedName(t, n);
  }
  forEach(t) {
    this.init(),
      Array.from(this.normalizedNames.keys()).forEach((o) =>
        t(this.normalizedNames.get(o), this.headers.get(o))
      );
  }
};
var In = class {
  encodeKey(t) {
    return Cr(t);
  }
  encodeValue(t) {
    return Cr(t);
  }
  decodeKey(t) {
    return decodeURIComponent(t);
  }
  decodeValue(t) {
    return decodeURIComponent(t);
  }
};
function Cs(i, t) {
  let o = new Map();
  return (
    i.length > 0 &&
      i
        .replace(/^\?/, '')
        .split('&')
        .forEach((n) => {
          let r = n.indexOf('='),
            [a, s] =
              r == -1
                ? [t.decodeKey(n), '']
                : [t.decodeKey(n.slice(0, r)), t.decodeValue(n.slice(r + 1))],
            c = o.get(a) || [];
          c.push(s), o.set(a, c);
        }),
    o
  );
}
var Is = /%(\d[a-f0-9])/gi,
  Es = {
    40: '@',
    '3A': ':',
    24: '$',
    '2C': ',',
    '3B': ';',
    '3D': '=',
    '3F': '?',
    '2F': '/',
  };
function Cr(i) {
  return encodeURIComponent(i).replace(Is, (t, o) => Es[o] ?? t);
}
function ki(i) {
  return `${i}`;
}
var Vt = class i {
  constructor(t = {}) {
    if (
      ((this.updates = null),
      (this.cloneFrom = null),
      (this.encoder = t.encoder || new In()),
      t.fromString)
    ) {
      if (t.fromObject)
        throw new Error('Cannot specify both fromString and fromObject.');
      this.map = Cs(t.fromString, this.encoder);
    } else
      t.fromObject
        ? ((this.map = new Map()),
          Object.keys(t.fromObject).forEach((o) => {
            let e = t.fromObject[o],
              n = Array.isArray(e) ? e.map(ki) : [ki(e)];
            this.map.set(o, n);
          }))
        : (this.map = null);
  }
  has(t) {
    return this.init(), this.map.has(t);
  }
  get(t) {
    this.init();
    let o = this.map.get(t);
    return o ? o[0] : null;
  }
  getAll(t) {
    return this.init(), this.map.get(t) || null;
  }
  keys() {
    return this.init(), Array.from(this.map.keys());
  }
  append(t, o) {
    return this.clone({ param: t, value: o, op: 'a' });
  }
  appendAll(t) {
    let o = [];
    return (
      Object.keys(t).forEach((e) => {
        let n = t[e];
        Array.isArray(n)
          ? n.forEach((r) => {
              o.push({ param: e, value: r, op: 'a' });
            })
          : o.push({ param: e, value: n, op: 'a' });
      }),
      this.clone(o)
    );
  }
  set(t, o) {
    return this.clone({ param: t, value: o, op: 's' });
  }
  delete(t, o) {
    return this.clone({ param: t, value: o, op: 'd' });
  }
  toString() {
    return (
      this.init(),
      this.keys()
        .map((t) => {
          let o = this.encoder.encodeKey(t);
          return this.map
            .get(t)
            .map((e) => o + '=' + this.encoder.encodeValue(e))
            .join('&');
        })
        .filter((t) => t !== '')
        .join('&')
    );
  }
  clone(t) {
    let o = new i({ encoder: this.encoder });
    return (
      (o.cloneFrom = this.cloneFrom || this),
      (o.updates = (this.updates || []).concat(t)),
      o
    );
  }
  init() {
    this.map === null && (this.map = new Map()),
      this.cloneFrom !== null &&
        (this.cloneFrom.init(),
        this.cloneFrom
          .keys()
          .forEach((t) => this.map.set(t, this.cloneFrom.map.get(t))),
        this.updates.forEach((t) => {
          switch (t.op) {
            case 'a':
            case 's':
              let o = (t.op === 'a' ? this.map.get(t.param) : void 0) || [];
              o.push(ki(t.value)), this.map.set(t.param, o);
              break;
            case 'd':
              if (t.value !== void 0) {
                let e = this.map.get(t.param) || [],
                  n = e.indexOf(ki(t.value));
                n !== -1 && e.splice(n, 1),
                  e.length > 0
                    ? this.map.set(t.param, e)
                    : this.map.delete(t.param);
              } else {
                this.map.delete(t.param);
                break;
              }
          }
        }),
        (this.cloneFrom = this.updates = null));
  }
};
var En = class {
  constructor() {
    this.map = new Map();
  }
  set(t, o) {
    return this.map.set(t, o), this;
  }
  get(t) {
    return (
      this.map.has(t) || this.map.set(t, t.defaultValue()), this.map.get(t)
    );
  }
  delete(t) {
    return this.map.delete(t), this;
  }
  has(t) {
    return this.map.has(t);
  }
  keys() {
    return this.map.keys();
  }
};
function Ds(i) {
  switch (i) {
    case 'DELETE':
    case 'GET':
    case 'HEAD':
    case 'OPTIONS':
    case 'JSONP':
      return !1;
    default:
      return !0;
  }
}
function Ir(i) {
  return typeof ArrayBuffer < 'u' && i instanceof ArrayBuffer;
}
function Er(i) {
  return typeof Blob < 'u' && i instanceof Blob;
}
function Dr(i) {
  return typeof FormData < 'u' && i instanceof FormData;
}
function As(i) {
  return typeof URLSearchParams < 'u' && i instanceof URLSearchParams;
}
var Pe = class i {
    constructor(t, o, e, n) {
      (this.url = o),
        (this.body = null),
        (this.reportProgress = !1),
        (this.withCredentials = !1),
        (this.responseType = 'json'),
        (this.method = t.toUpperCase());
      let r;
      if (
        (Ds(this.method) || n
          ? ((this.body = e !== void 0 ? e : null), (r = n))
          : (r = e),
        r &&
          ((this.reportProgress = !!r.reportProgress),
          (this.withCredentials = !!r.withCredentials),
          r.responseType && (this.responseType = r.responseType),
          r.headers && (this.headers = r.headers),
          r.context && (this.context = r.context),
          r.params && (this.params = r.params),
          (this.transferCache = r.transferCache)),
        (this.headers ??= new Zt()),
        (this.context ??= new En()),
        !this.params)
      )
        (this.params = new Vt()), (this.urlWithParams = o);
      else {
        let a = this.params.toString();
        if (a.length === 0) this.urlWithParams = o;
        else {
          let s = o.indexOf('?'),
            c = s === -1 ? '?' : s < o.length - 1 ? '&' : '';
          this.urlWithParams = o + c + a;
        }
      }
    }
    serializeBody() {
      return this.body === null
        ? null
        : typeof this.body == 'string' ||
            Ir(this.body) ||
            Er(this.body) ||
            Dr(this.body) ||
            As(this.body)
          ? this.body
          : this.body instanceof Vt
            ? this.body.toString()
            : typeof this.body == 'object' ||
                typeof this.body == 'boolean' ||
                Array.isArray(this.body)
              ? JSON.stringify(this.body)
              : this.body.toString();
    }
    detectContentTypeHeader() {
      return this.body === null || Dr(this.body)
        ? null
        : Er(this.body)
          ? this.body.type || null
          : Ir(this.body)
            ? null
            : typeof this.body == 'string'
              ? 'text/plain'
              : this.body instanceof Vt
                ? 'application/x-www-form-urlencoded;charset=UTF-8'
                : typeof this.body == 'object' ||
                    typeof this.body == 'number' ||
                    typeof this.body == 'boolean'
                  ? 'application/json'
                  : null;
    }
    clone(t = {}) {
      let o = t.method || this.method,
        e = t.url || this.url,
        n = t.responseType || this.responseType,
        r = t.transferCache ?? this.transferCache,
        a = t.body !== void 0 ? t.body : this.body,
        s = t.withCredentials ?? this.withCredentials,
        c = t.reportProgress ?? this.reportProgress,
        d = t.headers || this.headers,
        l = t.params || this.params,
        m = t.context ?? this.context;
      return (
        t.setHeaders !== void 0 &&
          (d = Object.keys(t.setHeaders).reduce(
            (p, I) => p.set(I, t.setHeaders[I]),
            d
          )),
        t.setParams &&
          (l = Object.keys(t.setParams).reduce(
            (p, I) => p.set(I, t.setParams[I]),
            l
          )),
        new i(o, e, a, {
          params: l,
          headers: d,
          context: m,
          reportProgress: c,
          responseType: n,
          withCredentials: s,
          transferCache: r,
        })
      );
    }
  },
  Nr = (function (i) {
    return (
      (i[(i.Sent = 0)] = 'Sent'),
      (i[(i.UploadProgress = 1)] = 'UploadProgress'),
      (i[(i.ResponseHeader = 2)] = 'ResponseHeader'),
      (i[(i.DownloadProgress = 3)] = 'DownloadProgress'),
      (i[(i.Response = 4)] = 'Response'),
      (i[(i.User = 5)] = 'User'),
      i
    );
  })(Nr || {}),
  Dn = class {
    constructor(t, o = Pr.Ok, e = 'OK') {
      (this.headers = t.headers || new Zt()),
        (this.status = t.status !== void 0 ? t.status : o),
        (this.statusText = t.statusText || e),
        (this.url = t.url || null),
        (this.ok = this.status >= 200 && this.status < 300);
    }
  };
var Ve = class i extends Dn {
  constructor(t = {}) {
    super(t),
      (this.type = Nr.Response),
      (this.body = t.body !== void 0 ? t.body : null);
  }
  clone(t = {}) {
    return new i({
      body: t.body !== void 0 ? t.body : this.body,
      headers: t.headers || this.headers,
      status: t.status !== void 0 ? t.status : this.status,
      statusText: t.statusText || this.statusText,
      url: t.url || this.url || void 0,
    });
  }
};
var Pr = (function (i) {
  return (
    (i[(i.Continue = 100)] = 'Continue'),
    (i[(i.SwitchingProtocols = 101)] = 'SwitchingProtocols'),
    (i[(i.Processing = 102)] = 'Processing'),
    (i[(i.EarlyHints = 103)] = 'EarlyHints'),
    (i[(i.Ok = 200)] = 'Ok'),
    (i[(i.Created = 201)] = 'Created'),
    (i[(i.Accepted = 202)] = 'Accepted'),
    (i[(i.NonAuthoritativeInformation = 203)] = 'NonAuthoritativeInformation'),
    (i[(i.NoContent = 204)] = 'NoContent'),
    (i[(i.ResetContent = 205)] = 'ResetContent'),
    (i[(i.PartialContent = 206)] = 'PartialContent'),
    (i[(i.MultiStatus = 207)] = 'MultiStatus'),
    (i[(i.AlreadyReported = 208)] = 'AlreadyReported'),
    (i[(i.ImUsed = 226)] = 'ImUsed'),
    (i[(i.MultipleChoices = 300)] = 'MultipleChoices'),
    (i[(i.MovedPermanently = 301)] = 'MovedPermanently'),
    (i[(i.Found = 302)] = 'Found'),
    (i[(i.SeeOther = 303)] = 'SeeOther'),
    (i[(i.NotModified = 304)] = 'NotModified'),
    (i[(i.UseProxy = 305)] = 'UseProxy'),
    (i[(i.Unused = 306)] = 'Unused'),
    (i[(i.TemporaryRedirect = 307)] = 'TemporaryRedirect'),
    (i[(i.PermanentRedirect = 308)] = 'PermanentRedirect'),
    (i[(i.BadRequest = 400)] = 'BadRequest'),
    (i[(i.Unauthorized = 401)] = 'Unauthorized'),
    (i[(i.PaymentRequired = 402)] = 'PaymentRequired'),
    (i[(i.Forbidden = 403)] = 'Forbidden'),
    (i[(i.NotFound = 404)] = 'NotFound'),
    (i[(i.MethodNotAllowed = 405)] = 'MethodNotAllowed'),
    (i[(i.NotAcceptable = 406)] = 'NotAcceptable'),
    (i[(i.ProxyAuthenticationRequired = 407)] = 'ProxyAuthenticationRequired'),
    (i[(i.RequestTimeout = 408)] = 'RequestTimeout'),
    (i[(i.Conflict = 409)] = 'Conflict'),
    (i[(i.Gone = 410)] = 'Gone'),
    (i[(i.LengthRequired = 411)] = 'LengthRequired'),
    (i[(i.PreconditionFailed = 412)] = 'PreconditionFailed'),
    (i[(i.PayloadTooLarge = 413)] = 'PayloadTooLarge'),
    (i[(i.UriTooLong = 414)] = 'UriTooLong'),
    (i[(i.UnsupportedMediaType = 415)] = 'UnsupportedMediaType'),
    (i[(i.RangeNotSatisfiable = 416)] = 'RangeNotSatisfiable'),
    (i[(i.ExpectationFailed = 417)] = 'ExpectationFailed'),
    (i[(i.ImATeapot = 418)] = 'ImATeapot'),
    (i[(i.MisdirectedRequest = 421)] = 'MisdirectedRequest'),
    (i[(i.UnprocessableEntity = 422)] = 'UnprocessableEntity'),
    (i[(i.Locked = 423)] = 'Locked'),
    (i[(i.FailedDependency = 424)] = 'FailedDependency'),
    (i[(i.TooEarly = 425)] = 'TooEarly'),
    (i[(i.UpgradeRequired = 426)] = 'UpgradeRequired'),
    (i[(i.PreconditionRequired = 428)] = 'PreconditionRequired'),
    (i[(i.TooManyRequests = 429)] = 'TooManyRequests'),
    (i[(i.RequestHeaderFieldsTooLarge = 431)] = 'RequestHeaderFieldsTooLarge'),
    (i[(i.UnavailableForLegalReasons = 451)] = 'UnavailableForLegalReasons'),
    (i[(i.InternalServerError = 500)] = 'InternalServerError'),
    (i[(i.NotImplemented = 501)] = 'NotImplemented'),
    (i[(i.BadGateway = 502)] = 'BadGateway'),
    (i[(i.ServiceUnavailable = 503)] = 'ServiceUnavailable'),
    (i[(i.GatewayTimeout = 504)] = 'GatewayTimeout'),
    (i[(i.HttpVersionNotSupported = 505)] = 'HttpVersionNotSupported'),
    (i[(i.VariantAlsoNegotiates = 506)] = 'VariantAlsoNegotiates'),
    (i[(i.InsufficientStorage = 507)] = 'InsufficientStorage'),
    (i[(i.LoopDetected = 508)] = 'LoopDetected'),
    (i[(i.NotExtended = 510)] = 'NotExtended'),
    (i[(i.NetworkAuthenticationRequired = 511)] =
      'NetworkAuthenticationRequired'),
    i
  );
})(Pr || {});
function kn(i, t) {
  return {
    body: t,
    headers: i.headers,
    context: i.context,
    observe: i.observe,
    params: i.params,
    reportProgress: i.reportProgress,
    responseType: i.responseType,
    withCredentials: i.withCredentials,
    transferCache: i.transferCache,
  };
}
var Vr = (() => {
  let t = class t {
    constructor(e) {
      this.handler = e;
    }
    request(e, n, r = {}) {
      let a;
      if (e instanceof Pe) a = e;
      else {
        let d;
        r.headers instanceof Zt ? (d = r.headers) : (d = new Zt(r.headers));
        let l;
        r.params &&
          (r.params instanceof Vt
            ? (l = r.params)
            : (l = new Vt({ fromObject: r.params }))),
          (a = new Pe(e, n, r.body !== void 0 ? r.body : null, {
            headers: d,
            context: r.context,
            params: l,
            reportProgress: r.reportProgress,
            responseType: r.responseType || 'json',
            withCredentials: r.withCredentials,
            transferCache: r.transferCache,
          }));
      }
      let s = b(a).pipe($t((d) => this.handler.handle(d)));
      if (e instanceof Pe || r.observe === 'events') return s;
      let c = s.pipe(It((d) => d instanceof Ve));
      switch (r.observe || 'body') {
        case 'body':
          switch (a.responseType) {
            case 'arraybuffer':
              return c.pipe(
                x((d) => {
                  if (d.body !== null && !(d.body instanceof ArrayBuffer))
                    throw new Error('Response is not an ArrayBuffer.');
                  return d.body;
                })
              );
            case 'blob':
              return c.pipe(
                x((d) => {
                  if (d.body !== null && !(d.body instanceof Blob))
                    throw new Error('Response is not a Blob.');
                  return d.body;
                })
              );
            case 'text':
              return c.pipe(
                x((d) => {
                  if (d.body !== null && typeof d.body != 'string')
                    throw new Error('Response is not a string.');
                  return d.body;
                })
              );
            case 'json':
            default:
              return c.pipe(x((d) => d.body));
          }
        case 'response':
          return c;
        default:
          throw new Error(`Unreachable: unhandled observe type ${r.observe}}`);
      }
    }
    delete(e, n = {}) {
      return this.request('DELETE', e, n);
    }
    get(e, n = {}) {
      return this.request('GET', e, n);
    }
    head(e, n = {}) {
      return this.request('HEAD', e, n);
    }
    jsonp(e, n) {
      return this.request('JSONP', e, {
        params: new Vt().append(n, 'JSONP_CALLBACK'),
        observe: 'body',
        responseType: 'json',
      });
    }
    options(e, n = {}) {
      return this.request('OPTIONS', e, n);
    }
    patch(e, n, r = {}) {
      return this.request('PATCH', e, kn(r, n));
    }
    post(e, n, r = {}) {
      return this.request('POST', e, kn(r, n));
    }
    put(e, n, r = {}) {
      return this.request('PUT', e, kn(r, n));
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)(f(Cn));
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac }));
  let i = t;
  return i;
})();
var Ms = new C('');
var Ar = 'b',
  Mr = 'h',
  Tr = 's',
  Sr = 'st',
  Rr = 'u',
  Fr = 'rt',
  Ci = new C(''),
  Ts = ['GET', 'HEAD'];
function Ss(i, t) {
  let m = h(Ci),
    { isCacheActive: o } = m,
    e = Bo(m, ['isCacheActive']),
    { transferCache: n, method: r } = i;
  if (
    !o ||
    (r === 'POST' && !e.includePostRequests && !n) ||
    (r !== 'POST' && !Ts.includes(r)) ||
    n === !1 ||
    e.filter?.(i) === !1
  )
    return t(i);
  let a = h(hi),
    s = Fs(i),
    c = a.get(s, null),
    d = e.includeHeaders;
  if ((typeof n == 'object' && n.includeHeaders && (d = n.includeHeaders), c)) {
    let { [Ar]: p, [Fr]: I, [Mr]: gt, [Tr]: Z, [Sr]: At, [Rr]: dt } = c,
      Mt = p;
    switch (I) {
      case 'arraybuffer':
        Mt = new TextEncoder().encode(p).buffer;
        break;
      case 'blob':
        Mt = new Blob([p]);
        break;
    }
    let ys = new Zt(gt);
    return b(
      new Ve({ body: Mt, headers: ys, status: Z, statusText: At, url: dt })
    );
  }
  let l = Ne(h(Et));
  return t(i).pipe(
    R((p) => {
      p instanceof Ve &&
        l &&
        a.set(s, {
          [Ar]: p.body,
          [Mr]: Rs(p.headers, d),
          [Tr]: p.status,
          [Sr]: p.statusText,
          [Rr]: p.url || '',
          [Fr]: i.responseType,
        });
    })
  );
}
function Rs(i, t) {
  if (!t) return {};
  let o = {};
  for (let e of t) {
    let n = i.getAll(e);
    n !== null && (o[e] = n);
  }
  return o;
}
function Or(i) {
  return [...i.keys()]
    .sort()
    .map((t) => `${t}=${i.getAll(t)}`)
    .join('&');
}
function Fs(i) {
  let { params: t, method: o, responseType: e, url: n } = i,
    r = Or(t),
    a = i.serializeBody();
  a instanceof URLSearchParams ? (a = Or(a)) : typeof a != 'string' && (a = '');
  let s = [o, e, n, a, r].join('|'),
    c = Os(s);
  return c;
}
function Os(i) {
  let t = 0;
  for (let o of i) t = (Math.imul(31, t) + o.charCodeAt(0)) << 0;
  return (t += 2147483648), t.toString();
}
function jr(i) {
  return [
    {
      provide: Ci,
      useFactory: () => (
        pi('NgHttpTransferCache'), u({ isCacheActive: !0 }, i)
      ),
    },
    { provide: Ms, useValue: Ss, multi: !0, deps: [hi, Ci] },
    {
      provide: xi,
      multi: !0,
      useFactory: () => {
        let t = h(Oe),
          o = h(Ci);
        return () => {
          fr(t).then(() => {
            o.isCacheActive = !1;
          });
        };
      },
    },
  ];
}
var Tn = class extends yr {
    constructor() {
      super(...arguments), (this.supportsDOMEvents = !0);
    }
  },
  Sn = class i extends Tn {
    static makeCurrent() {
      _r(new i());
    }
    onAndCancel(t, o, e) {
      return (
        t.addEventListener(o, e),
        () => {
          t.removeEventListener(o, e);
        }
      );
    }
    dispatchEvent(t, o) {
      t.dispatchEvent(o);
    }
    remove(t) {
      t.parentNode && t.parentNode.removeChild(t);
    }
    createElement(t, o) {
      return (o = o || this.getDefaultDocument()), o.createElement(t);
    }
    createHtmlDocument() {
      return document.implementation.createHTMLDocument('fakeTitle');
    }
    getDefaultDocument() {
      return document;
    }
    isElementNode(t) {
      return t.nodeType === Node.ELEMENT_NODE;
    }
    isShadowRoot(t) {
      return t instanceof DocumentFragment;
    }
    getGlobalEventTarget(t, o) {
      return o === 'window'
        ? window
        : o === 'document'
          ? t
          : o === 'body'
            ? t.body
            : null;
    }
    getBaseHref(t) {
      let o = Vs();
      return o == null ? null : js(o);
    }
    resetBaseElement() {
      je = null;
    }
    getUserAgent() {
      return window.navigator.userAgent;
    }
    getCookie(t) {
      return xn(document.cookie, t);
    }
  },
  je = null;
function Vs() {
  return (
    (je = je || document.querySelector('base')),
    je ? je.getAttribute('href') : null
  );
}
function js(i) {
  return new URL(i, document.baseURI).pathname;
}
var Ls = (() => {
    let t = class t {
      build() {
        return new XMLHttpRequest();
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })(),
  Rn = new C(''),
  Br = (() => {
    let t = class t {
      constructor(e, n) {
        (this._zone = n),
          (this._eventNameToPlugin = new Map()),
          e.forEach((r) => {
            r.manager = this;
          }),
          (this._plugins = e.slice().reverse());
      }
      addEventListener(e, n, r) {
        return this._findPluginFor(n).addEventListener(e, n, r);
      }
      getZone() {
        return this._zone;
      }
      _findPluginFor(e) {
        let n = this._eventNameToPlugin.get(e);
        if (n) return n;
        if (((n = this._plugins.find((a) => a.supports(e))), !n))
          throw new M(5101, !1);
        return this._eventNameToPlugin.set(e, n), n;
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(Rn), f(A));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })(),
  Ii = class {
    constructor(t) {
      this._doc = t;
    }
  },
  An = 'ng-app-id',
  $r = (() => {
    let t = class t {
      constructor(e, n, r, a = {}) {
        (this.doc = e),
          (this.appId = n),
          (this.nonce = r),
          (this.platformId = a),
          (this.styleRef = new Map()),
          (this.hostNodes = new Set()),
          (this.styleNodesInDOM = this.collectServerRenderedStyles()),
          (this.platformIsServer = Ne(a)),
          this.resetHostNodes();
      }
      addStyles(e) {
        for (let n of e)
          this.changeUsageCount(n, 1) === 1 && this.onStyleAdded(n);
      }
      removeStyles(e) {
        for (let n of e)
          this.changeUsageCount(n, -1) <= 0 && this.onStyleRemoved(n);
      }
      ngOnDestroy() {
        let e = this.styleNodesInDOM;
        e && (e.forEach((n) => n.remove()), e.clear());
        for (let n of this.getAllStyles()) this.onStyleRemoved(n);
        this.resetHostNodes();
      }
      addHost(e) {
        this.hostNodes.add(e);
        for (let n of this.getAllStyles()) this.addStyleToHost(e, n);
      }
      removeHost(e) {
        this.hostNodes.delete(e);
      }
      getAllStyles() {
        return this.styleRef.keys();
      }
      onStyleAdded(e) {
        for (let n of this.hostNodes) this.addStyleToHost(n, e);
      }
      onStyleRemoved(e) {
        let n = this.styleRef;
        n.get(e)?.elements?.forEach((r) => r.remove()), n.delete(e);
      }
      collectServerRenderedStyles() {
        let e = this.doc.head?.querySelectorAll(`style[${An}="${this.appId}"]`);
        if (e?.length) {
          let n = new Map();
          return (
            e.forEach((r) => {
              r.textContent != null && n.set(r.textContent, r);
            }),
            n
          );
        }
        return null;
      }
      changeUsageCount(e, n) {
        let r = this.styleRef;
        if (r.has(e)) {
          let a = r.get(e);
          return (a.usage += n), a.usage;
        }
        return r.set(e, { usage: n, elements: [] }), n;
      }
      getStyleElement(e, n) {
        let r = this.styleNodesInDOM,
          a = r?.get(n);
        if (a?.parentNode === e) return r.delete(n), a.removeAttribute(An), a;
        {
          let s = this.doc.createElement('style');
          return (
            this.nonce && s.setAttribute('nonce', this.nonce),
            (s.textContent = n),
            this.platformIsServer && s.setAttribute(An, this.appId),
            e.appendChild(s),
            s
          );
        }
      }
      addStyleToHost(e, n) {
        let r = this.getStyleElement(e, n),
          a = this.styleRef,
          s = a.get(n)?.elements;
        s ? s.push(r) : a.set(n, { elements: [r], usage: 1 });
      }
      resetHostNodes() {
        let e = this.hostNodes;
        e.clear(), e.add(this.doc.head);
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(S), f(ui), f(Me, 8), f(Et));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })(),
  Mn = {
    svg: 'http://www.w3.org/2000/svg',
    xhtml: 'http://www.w3.org/1999/xhtml',
    xlink: 'http://www.w3.org/1999/xlink',
    xml: 'http://www.w3.org/XML/1998/namespace',
    xmlns: 'http://www.w3.org/2000/xmlns/',
    math: 'http://www.w3.org/1998/MathML/',
  },
  Pn = /%COMP%/g,
  Hr = '%COMP%',
  Us = `_nghost-${Hr}`,
  zs = `_ngcontent-${Hr}`,
  Bs = !0,
  $s = new C('', { providedIn: 'root', factory: () => Bs });
function Hs(i) {
  return zs.replace(Pn, i);
}
function Gs(i) {
  return Us.replace(Pn, i);
}
function Gr(i, t) {
  return t.map((o) => o.replace(Pn, i));
}
var Ei = (() => {
    let t = class t {
      constructor(e, n, r, a, s, c, d, l = null) {
        (this.eventManager = e),
          (this.sharedStylesHost = n),
          (this.appId = r),
          (this.removeStylesOnCompDestroy = a),
          (this.doc = s),
          (this.platformId = c),
          (this.ngZone = d),
          (this.nonce = l),
          (this.rendererByCompId = new Map()),
          (this.platformIsServer = Ne(c)),
          (this.defaultRenderer = new Le(e, s, d, this.platformIsServer));
      }
      createRenderer(e, n) {
        if (!e || !n) return this.defaultRenderer;
        this.platformIsServer &&
          n.encapsulation === Ie.ShadowDom &&
          (n = U(u({}, n), { encapsulation: Ie.Emulated }));
        let r = this.getOrCreateRenderer(e, n);
        return (
          r instanceof Di
            ? r.applyToHost(e)
            : r instanceof Ue && r.applyStyles(),
          r
        );
      }
      getOrCreateRenderer(e, n) {
        let r = this.rendererByCompId,
          a = r.get(n.id);
        if (!a) {
          let s = this.doc,
            c = this.ngZone,
            d = this.eventManager,
            l = this.sharedStylesHost,
            m = this.removeStylesOnCompDestroy,
            p = this.platformIsServer;
          switch (n.encapsulation) {
            case Ie.Emulated:
              a = new Di(d, l, n, this.appId, m, s, c, p);
              break;
            case Ie.ShadowDom:
              return new Fn(d, l, e, n, s, c, this.nonce, p);
            default:
              a = new Ue(d, l, n, m, s, c, p);
              break;
          }
          r.set(n.id, a);
        }
        return a;
      }
      ngOnDestroy() {
        this.rendererByCompId.clear();
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(Br), f($r), f(ui), f($s), f(S), f(Et), f(A), f(Me));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })(),
  Le = class {
    constructor(t, o, e, n) {
      (this.eventManager = t),
        (this.doc = o),
        (this.ngZone = e),
        (this.platformIsServer = n),
        (this.data = Object.create(null)),
        (this.throwOnSyntheticProps = !0),
        (this.destroyNode = null);
    }
    destroy() {}
    createElement(t, o) {
      return o
        ? this.doc.createElementNS(Mn[o] || o, t)
        : this.doc.createElement(t);
    }
    createComment(t) {
      return this.doc.createComment(t);
    }
    createText(t) {
      return this.doc.createTextNode(t);
    }
    appendChild(t, o) {
      (Lr(t) ? t.content : t).appendChild(o);
    }
    insertBefore(t, o, e) {
      t && (Lr(t) ? t.content : t).insertBefore(o, e);
    }
    removeChild(t, o) {
      t && t.removeChild(o);
    }
    selectRootElement(t, o) {
      let e = typeof t == 'string' ? this.doc.querySelector(t) : t;
      if (!e) throw new M(-5104, !1);
      return o || (e.textContent = ''), e;
    }
    parentNode(t) {
      return t.parentNode;
    }
    nextSibling(t) {
      return t.nextSibling;
    }
    setAttribute(t, o, e, n) {
      if (n) {
        o = n + ':' + o;
        let r = Mn[n];
        r ? t.setAttributeNS(r, o, e) : t.setAttribute(o, e);
      } else t.setAttribute(o, e);
    }
    removeAttribute(t, o, e) {
      if (e) {
        let n = Mn[e];
        n ? t.removeAttributeNS(n, o) : t.removeAttribute(`${e}:${o}`);
      } else t.removeAttribute(o);
    }
    addClass(t, o) {
      t.classList.add(o);
    }
    removeClass(t, o) {
      t.classList.remove(o);
    }
    setStyle(t, o, e, n) {
      n & (Te.DashCase | Te.Important)
        ? t.style.setProperty(o, e, n & Te.Important ? 'important' : '')
        : (t.style[o] = e);
    }
    removeStyle(t, o, e) {
      e & Te.DashCase ? t.style.removeProperty(o) : (t.style[o] = '');
    }
    setProperty(t, o, e) {
      t != null && (t[o] = e);
    }
    setValue(t, o) {
      t.nodeValue = o;
    }
    listen(t, o, e) {
      if (
        typeof t == 'string' &&
        ((t = yn().getGlobalEventTarget(this.doc, t)), !t)
      )
        throw new Error(`Unsupported event target ${t} for event ${o}`);
      return this.eventManager.addEventListener(
        t,
        o,
        this.decoratePreventDefault(e)
      );
    }
    decoratePreventDefault(t) {
      return (o) => {
        if (o === '__ngUnwrap__') return t;
        (this.platformIsServer ? this.ngZone.runGuarded(() => t(o)) : t(o)) ===
          !1 && o.preventDefault();
      };
    }
  };
function Lr(i) {
  return i.tagName === 'TEMPLATE' && i.content !== void 0;
}
var Fn = class extends Le {
    constructor(t, o, e, n, r, a, s, c) {
      super(t, r, a, c),
        (this.sharedStylesHost = o),
        (this.hostEl = e),
        (this.shadowRoot = e.attachShadow({ mode: 'open' })),
        this.sharedStylesHost.addHost(this.shadowRoot);
      let d = Gr(n.id, n.styles);
      for (let l of d) {
        let m = document.createElement('style');
        s && m.setAttribute('nonce', s),
          (m.textContent = l),
          this.shadowRoot.appendChild(m);
      }
    }
    nodeOrShadowRoot(t) {
      return t === this.hostEl ? this.shadowRoot : t;
    }
    appendChild(t, o) {
      return super.appendChild(this.nodeOrShadowRoot(t), o);
    }
    insertBefore(t, o, e) {
      return super.insertBefore(this.nodeOrShadowRoot(t), o, e);
    }
    removeChild(t, o) {
      return super.removeChild(this.nodeOrShadowRoot(t), o);
    }
    parentNode(t) {
      return this.nodeOrShadowRoot(super.parentNode(this.nodeOrShadowRoot(t)));
    }
    destroy() {
      this.sharedStylesHost.removeHost(this.shadowRoot);
    }
  },
  Ue = class extends Le {
    constructor(t, o, e, n, r, a, s, c) {
      super(t, r, a, s),
        (this.sharedStylesHost = o),
        (this.removeStylesOnCompDestroy = n),
        (this.styles = c ? Gr(c, e.styles) : e.styles);
    }
    applyStyles() {
      this.sharedStylesHost.addStyles(this.styles);
    }
    destroy() {
      this.removeStylesOnCompDestroy &&
        this.sharedStylesHost.removeStyles(this.styles);
    }
  },
  Di = class extends Ue {
    constructor(t, o, e, n, r, a, s, c) {
      let d = n + '-' + e.id;
      super(t, o, e, r, a, s, c, d),
        (this.contentAttr = Hs(d)),
        (this.hostAttr = Gs(d));
    }
    applyToHost(t) {
      this.applyStyles(), this.setAttribute(t, this.hostAttr, '');
    }
    createElement(t, o) {
      let e = super.createElement(t, o);
      return super.setAttribute(e, this.contentAttr, ''), e;
    }
  },
  qs = (() => {
    let t = class t extends Ii {
      constructor(e) {
        super(e);
      }
      supports(e) {
        return !0;
      }
      addEventListener(e, n, r) {
        return (
          e.addEventListener(n, r, !1), () => this.removeEventListener(e, n, r)
        );
      }
      removeEventListener(e, n, r) {
        return e.removeEventListener(n, r);
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(S));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })(),
  Ur = ['alt', 'control', 'meta', 'shift'],
  Ws = {
    '\b': 'Backspace',
    '	': 'Tab',
    '\x7F': 'Delete',
    '\x1B': 'Escape',
    Del: 'Delete',
    Esc: 'Escape',
    Left: 'ArrowLeft',
    Right: 'ArrowRight',
    Up: 'ArrowUp',
    Down: 'ArrowDown',
    Menu: 'ContextMenu',
    Scroll: 'ScrollLock',
    Win: 'OS',
  },
  Ks = {
    alt: (i) => i.altKey,
    control: (i) => i.ctrlKey,
    meta: (i) => i.metaKey,
    shift: (i) => i.shiftKey,
  },
  Zs = (() => {
    let t = class t extends Ii {
      constructor(e) {
        super(e);
      }
      supports(e) {
        return t.parseEventName(e) != null;
      }
      addEventListener(e, n, r) {
        let a = t.parseEventName(n),
          s = t.eventCallback(a.fullKey, r, this.manager.getZone());
        return this.manager
          .getZone()
          .runOutsideAngular(() => yn().onAndCancel(e, a.domEventName, s));
      }
      static parseEventName(e) {
        let n = e.toLowerCase().split('.'),
          r = n.shift();
        if (n.length === 0 || !(r === 'keydown' || r === 'keyup')) return null;
        let a = t._normalizeKey(n.pop()),
          s = '',
          c = n.indexOf('code');
        if (
          (c > -1 && (n.splice(c, 1), (s = 'code.')),
          Ur.forEach((l) => {
            let m = n.indexOf(l);
            m > -1 && (n.splice(m, 1), (s += l + '.'));
          }),
          (s += a),
          n.length != 0 || a.length === 0)
        )
          return null;
        let d = {};
        return (d.domEventName = r), (d.fullKey = s), d;
      }
      static matchEventFullKeyCode(e, n) {
        let r = Ws[e.key] || e.key,
          a = '';
        return (
          n.indexOf('code.') > -1 && ((r = e.code), (a = 'code.')),
          r == null || !r
            ? !1
            : ((r = r.toLowerCase()),
              r === ' ' ? (r = 'space') : r === '.' && (r = 'dot'),
              Ur.forEach((s) => {
                if (s !== r) {
                  let c = Ks[s];
                  c(e) && (a += s + '.');
                }
              }),
              (a += r),
              a === n)
        );
      }
      static eventCallback(e, n, r) {
        return (a) => {
          t.matchEventFullKeyCode(a, e) && r.runGuarded(() => n(a));
        };
      }
      static _normalizeKey(e) {
        return e === 'esc' ? 'escape' : e;
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(S));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })();
function qr(i, t) {
  return br(u({ rootComponent: i }, Qs(t)));
}
function Qs(i) {
  return {
    appProviders: [...ec, ...(i?.providers ?? [])],
    platformProviders: tc,
  };
}
function Ys() {
  Sn.makeCurrent();
}
function Xs() {
  return new qt();
}
function Js() {
  return er(document), document;
}
var tc = [
  { provide: Et, useValue: xr },
  { provide: ir, useValue: Ys, multi: !0 },
  { provide: S, useFactory: Js, deps: [] },
];
var ec = [
  { provide: Jo, useValue: 'root' },
  { provide: qt, useFactory: Xs, deps: [] },
  { provide: Rn, useClass: qs, multi: !0, deps: [S, A, Et] },
  { provide: Rn, useClass: Zs, multi: !0, deps: [S] },
  Ei,
  $r,
  Br,
  { provide: mi, useExisting: Ei },
  { provide: kr, useClass: Ls, deps: [] },
  [],
];
var Wr = (() => {
  let t = class t {
    constructor(e) {
      this._doc = e;
    }
    getTitle() {
      return this._doc.title;
    }
    setTitle(e) {
      this._doc.title = e || '';
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)(f(S));
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
  let i = t;
  return i;
})();
var Vn = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({
        token: t,
        factory: function (n) {
          let r = null;
          return n ? (r = new (n || t)()) : (r = f(ic)), r;
        },
        providedIn: 'root',
      }));
    let i = t;
    return i;
  })(),
  ic = (() => {
    let t = class t extends Vn {
      constructor(e) {
        super(), (this._doc = e);
      }
      sanitize(e, n) {
        if (n == null) return null;
        switch (e) {
          case nt.NONE:
            return n;
          case nt.HTML:
            return se(n, 'HTML') ? ae(n) : dr(this._doc, String(n)).toString();
          case nt.STYLE:
            return se(n, 'Style') ? ae(n) : n;
          case nt.SCRIPT:
            if (se(n, 'Script')) return ae(n);
            throw new M(5200, !1);
          case nt.URL:
            return se(n, 'URL') ? ae(n) : cr(String(n));
          case nt.RESOURCE_URL:
            if (se(n, 'ResourceURL')) return ae(n);
            throw new M(5201, !1);
          default:
            throw new M(5202, !1);
        }
      }
      bypassSecurityTrustHtml(e) {
        return nr(e);
      }
      bypassSecurityTrustStyle(e) {
        return or(e);
      }
      bypassSecurityTrustScript(e) {
        return rr(e);
      }
      bypassSecurityTrustUrl(e) {
        return ar(e);
      }
      bypassSecurityTrustResourceUrl(e) {
        return sr(e);
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(S));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  On = (function (i) {
    return (
      (i[(i.NoHttpTransferCache = 0)] = 'NoHttpTransferCache'),
      (i[(i.HttpTransferCacheOptions = 1)] = 'HttpTransferCacheOptions'),
      i
    );
  })(On || {});
function Kr(...i) {
  let t = [],
    o = new Set(),
    e = o.has(On.HttpTransferCacheOptions);
  for (let { ɵproviders: n, ɵkind: r } of i) o.add(r), n.length && t.push(n);
  return Gt([[], gr(), o.has(On.NoHttpTransferCache) || e ? [] : jr({}), t]);
}
var y = 'primary',
  ei = Symbol('RouteTitle'),
  Bn = class {
    constructor(t) {
      this.params = t || {};
    }
    has(t) {
      return Object.prototype.hasOwnProperty.call(this.params, t);
    }
    get(t) {
      if (this.has(t)) {
        let o = this.params[t];
        return Array.isArray(o) ? o[0] : o;
      }
      return null;
    }
    getAll(t) {
      if (this.has(t)) {
        let o = this.params[t];
        return Array.isArray(o) ? o : [o];
      }
      return [];
    }
    get keys() {
      return Object.keys(this.params);
    }
  };
function me(i) {
  return new Bn(i);
}
function oc(i, t, o) {
  let e = o.path.split('/');
  if (
    e.length > i.length ||
    (o.pathMatch === 'full' && (t.hasChildren() || e.length < i.length))
  )
    return null;
  let n = {};
  for (let r = 0; r < e.length; r++) {
    let a = e[r],
      s = i[r];
    if (a.startsWith(':')) n[a.substring(1)] = s;
    else if (a !== s.path) return null;
  }
  return { consumed: i.slice(0, e.length), posParams: n };
}
function rc(i, t) {
  if (i.length !== t.length) return !1;
  for (let o = 0; o < i.length; ++o) if (!kt(i[o], t[o])) return !1;
  return !0;
}
function kt(i, t) {
  let o = i ? $n(i) : void 0,
    e = t ? $n(t) : void 0;
  if (!o || !e || o.length != e.length) return !1;
  let n;
  for (let r = 0; r < o.length; r++)
    if (((n = o[r]), !ea(i[n], t[n]))) return !1;
  return !0;
}
function $n(i) {
  return [...Object.keys(i), ...Object.getOwnPropertySymbols(i)];
}
function ea(i, t) {
  if (Array.isArray(i) && Array.isArray(t)) {
    if (i.length !== t.length) return !1;
    let o = [...i].sort(),
      e = [...t].sort();
    return o.every((n, r) => e[r] === n);
  } else return i === t;
}
function ia(i) {
  return i.length > 0 ? i[i.length - 1] : null;
}
function Ut(i) {
  return Ho(i) ? i : gn(i) ? ut(Promise.resolve(i)) : b(i);
}
var ac = { exact: oa, subset: ra },
  na = { exact: sc, subset: cc, ignored: () => !0 };
function Qr(i, t, o) {
  return (
    ac[o.paths](i.root, t.root, o.matrixParams) &&
    na[o.queryParams](i.queryParams, t.queryParams) &&
    !(o.fragment === 'exact' && i.fragment !== t.fragment)
  );
}
function sc(i, t) {
  return kt(i, t);
}
function oa(i, t, o) {
  if (
    !Yt(i.segments, t.segments) ||
    !Ti(i.segments, t.segments, o) ||
    i.numberOfChildren !== t.numberOfChildren
  )
    return !1;
  for (let e in t.children)
    if (!i.children[e] || !oa(i.children[e], t.children[e], o)) return !1;
  return !0;
}
function cc(i, t) {
  return (
    Object.keys(t).length <= Object.keys(i).length &&
    Object.keys(t).every((o) => ea(i[o], t[o]))
  );
}
function ra(i, t, o) {
  return aa(i, t, t.segments, o);
}
function aa(i, t, o, e) {
  if (i.segments.length > o.length) {
    let n = i.segments.slice(0, o.length);
    return !(!Yt(n, o) || t.hasChildren() || !Ti(n, o, e));
  } else if (i.segments.length === o.length) {
    if (!Yt(i.segments, o) || !Ti(i.segments, o, e)) return !1;
    for (let n in t.children)
      if (!i.children[n] || !ra(i.children[n], t.children[n], e)) return !1;
    return !0;
  } else {
    let n = o.slice(0, i.segments.length),
      r = o.slice(i.segments.length);
    return !Yt(i.segments, n) || !Ti(i.segments, n, e) || !i.children[y]
      ? !1
      : aa(i.children[y], t, r, e);
  }
}
function Ti(i, t, o) {
  return t.every((e, n) => na[o](i[n].parameters, e.parameters));
}
var jt = class {
    constructor(t = new E([], {}), o = {}, e = null) {
      (this.root = t), (this.queryParams = o), (this.fragment = e);
    }
    get queryParamMap() {
      return (
        (this._queryParamMap ??= me(this.queryParams)), this._queryParamMap
      );
    }
    toString() {
      return uc.serialize(this);
    }
  },
  E = class {
    constructor(t, o) {
      (this.segments = t),
        (this.children = o),
        (this.parent = null),
        Object.values(o).forEach((e) => (e.parent = this));
    }
    hasChildren() {
      return this.numberOfChildren > 0;
    }
    get numberOfChildren() {
      return Object.keys(this.children).length;
    }
    toString() {
      return Si(this);
    }
  },
  Qt = class {
    constructor(t, o) {
      (this.path = t), (this.parameters = o);
    }
    get parameterMap() {
      return (this._parameterMap ??= me(this.parameters)), this._parameterMap;
    }
    toString() {
      return ca(this);
    }
  };
function dc(i, t) {
  return Yt(i, t) && i.every((o, e) => kt(o.parameters, t[e].parameters));
}
function Yt(i, t) {
  return i.length !== t.length ? !1 : i.every((o, e) => o.path === t[e].path);
}
function lc(i, t) {
  let o = [];
  return (
    Object.entries(i.children).forEach(([e, n]) => {
      e === y && (o = o.concat(t(n, e)));
    }),
    Object.entries(i.children).forEach(([e, n]) => {
      e !== y && (o = o.concat(t(n, e)));
    }),
    o
  );
}
var bo = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: () => new Fi(), providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Fi = class {
    parse(t) {
      let o = new Gn(t);
      return new jt(
        o.parseRootSegment(),
        o.parseQueryParams(),
        o.parseFragment()
      );
    }
    serialize(t) {
      let o = `/${ze(t.root, !0)}`,
        e = pc(t.queryParams),
        n = typeof t.fragment == 'string' ? `#${hc(t.fragment)}` : '';
      return `${o}${e}${n}`;
    }
  },
  uc = new Fi();
function Si(i) {
  return i.segments.map((t) => ca(t)).join('/');
}
function ze(i, t) {
  if (!i.hasChildren()) return Si(i);
  if (t) {
    let o = i.children[y] ? ze(i.children[y], !1) : '',
      e = [];
    return (
      Object.entries(i.children).forEach(([n, r]) => {
        n !== y && e.push(`${n}:${ze(r, !1)}`);
      }),
      e.length > 0 ? `${o}(${e.join('//')})` : o
    );
  } else {
    let o = lc(i, (e, n) =>
      n === y ? [ze(i.children[y], !1)] : [`${n}:${ze(e, !1)}`]
    );
    return Object.keys(i.children).length === 1 && i.children[y] != null
      ? `${Si(i)}/${o[0]}`
      : `${Si(i)}/(${o.join('//')})`;
  }
}
function sa(i) {
  return encodeURIComponent(i)
    .replace(/%40/g, '@')
    .replace(/%3A/gi, ':')
    .replace(/%24/g, '$')
    .replace(/%2C/gi, ',');
}
function Ai(i) {
  return sa(i).replace(/%3B/gi, ';');
}
function hc(i) {
  return encodeURI(i);
}
function Hn(i) {
  return sa(i)
    .replace(/\(/g, '%28')
    .replace(/\)/g, '%29')
    .replace(/%26/gi, '&');
}
function Ri(i) {
  return decodeURIComponent(i);
}
function Yr(i) {
  return Ri(i.replace(/\+/g, '%20'));
}
function ca(i) {
  return `${Hn(i.path)}${mc(i.parameters)}`;
}
function mc(i) {
  return Object.entries(i)
    .map(([t, o]) => `;${Hn(t)}=${Hn(o)}`)
    .join('');
}
function pc(i) {
  let t = Object.entries(i)
    .map(([o, e]) =>
      Array.isArray(e)
        ? e.map((n) => `${Ai(o)}=${Ai(n)}`).join('&')
        : `${Ai(o)}=${Ai(e)}`
    )
    .filter((o) => o);
  return t.length ? `?${t.join('&')}` : '';
}
var fc = /^[^\/()?;#]+/;
function jn(i) {
  let t = i.match(fc);
  return t ? t[0] : '';
}
var bc = /^[^\/()?;=#]+/;
function gc(i) {
  let t = i.match(bc);
  return t ? t[0] : '';
}
var vc = /^[^=?&#]+/;
function _c(i) {
  let t = i.match(vc);
  return t ? t[0] : '';
}
var yc = /^[^&#]+/;
function xc(i) {
  let t = i.match(yc);
  return t ? t[0] : '';
}
var Gn = class {
  constructor(t) {
    (this.url = t), (this.remaining = t);
  }
  parseRootSegment() {
    return (
      this.consumeOptional('/'),
      this.remaining === '' ||
      this.peekStartsWith('?') ||
      this.peekStartsWith('#')
        ? new E([], {})
        : new E([], this.parseChildren())
    );
  }
  parseQueryParams() {
    let t = {};
    if (this.consumeOptional('?'))
      do this.parseQueryParam(t);
      while (this.consumeOptional('&'));
    return t;
  }
  parseFragment() {
    return this.consumeOptional('#')
      ? decodeURIComponent(this.remaining)
      : null;
  }
  parseChildren() {
    if (this.remaining === '') return {};
    this.consumeOptional('/');
    let t = [];
    for (
      this.peekStartsWith('(') || t.push(this.parseSegment());
      this.peekStartsWith('/') &&
      !this.peekStartsWith('//') &&
      !this.peekStartsWith('/(');

    )
      this.capture('/'), t.push(this.parseSegment());
    let o = {};
    this.peekStartsWith('/(') &&
      (this.capture('/'), (o = this.parseParens(!0)));
    let e = {};
    return (
      this.peekStartsWith('(') && (e = this.parseParens(!1)),
      (t.length > 0 || Object.keys(o).length > 0) && (e[y] = new E(t, o)),
      e
    );
  }
  parseSegment() {
    let t = jn(this.remaining);
    if (t === '' && this.peekStartsWith(';')) throw new M(4009, !1);
    return this.capture(t), new Qt(Ri(t), this.parseMatrixParams());
  }
  parseMatrixParams() {
    let t = {};
    for (; this.consumeOptional(';'); ) this.parseParam(t);
    return t;
  }
  parseParam(t) {
    let o = gc(this.remaining);
    if (!o) return;
    this.capture(o);
    let e = '';
    if (this.consumeOptional('=')) {
      let n = jn(this.remaining);
      n && ((e = n), this.capture(e));
    }
    t[Ri(o)] = Ri(e);
  }
  parseQueryParam(t) {
    let o = _c(this.remaining);
    if (!o) return;
    this.capture(o);
    let e = '';
    if (this.consumeOptional('=')) {
      let a = xc(this.remaining);
      a && ((e = a), this.capture(e));
    }
    let n = Yr(o),
      r = Yr(e);
    if (t.hasOwnProperty(n)) {
      let a = t[n];
      Array.isArray(a) || ((a = [a]), (t[n] = a)), a.push(r);
    } else t[n] = r;
  }
  parseParens(t) {
    let o = {};
    for (
      this.capture('(');
      !this.consumeOptional(')') && this.remaining.length > 0;

    ) {
      let e = jn(this.remaining),
        n = this.remaining[e.length];
      if (n !== '/' && n !== ')' && n !== ';') throw new M(4010, !1);
      let r;
      e.indexOf(':') > -1
        ? ((r = e.slice(0, e.indexOf(':'))), this.capture(r), this.capture(':'))
        : t && (r = y);
      let a = this.parseChildren();
      (o[r] = Object.keys(a).length === 1 ? a[y] : new E([], a)),
        this.consumeOptional('//');
    }
    return o;
  }
  peekStartsWith(t) {
    return this.remaining.startsWith(t);
  }
  consumeOptional(t) {
    return this.peekStartsWith(t)
      ? ((this.remaining = this.remaining.substring(t.length)), !0)
      : !1;
  }
  capture(t) {
    if (!this.consumeOptional(t)) throw new M(4011, !1);
  }
};
function da(i) {
  return i.segments.length > 0 ? new E([], { [y]: i }) : i;
}
function la(i) {
  let t = {};
  for (let [e, n] of Object.entries(i.children)) {
    let r = la(n);
    if (e === y && r.segments.length === 0 && r.hasChildren())
      for (let [a, s] of Object.entries(r.children)) t[a] = s;
    else (r.segments.length > 0 || r.hasChildren()) && (t[e] = r);
  }
  let o = new E(i.segments, t);
  return wc(o);
}
function wc(i) {
  if (i.numberOfChildren === 1 && i.children[y]) {
    let t = i.children[y];
    return new E(i.segments.concat(t.segments), t.children);
  }
  return i;
}
function pe(i) {
  return i instanceof jt;
}
function kc(i, t, o = null, e = null) {
  let n = ua(i);
  return ha(n, t, o, e);
}
function ua(i) {
  let t;
  function o(r) {
    let a = {};
    for (let c of r.children) {
      let d = o(c);
      a[c.outlet] = d;
    }
    let s = new E(r.url, a);
    return r === i && (t = s), s;
  }
  let e = o(i.root),
    n = da(e);
  return t ?? n;
}
function ha(i, t, o, e) {
  let n = i;
  for (; n.parent; ) n = n.parent;
  if (t.length === 0) return Ln(n, n, n, o, e);
  let r = Cc(t);
  if (r.toRoot()) return Ln(n, n, new E([], {}), o, e);
  let a = Ic(r, n, i),
    s = a.processChildren
      ? He(a.segmentGroup, a.index, r.commands)
      : pa(a.segmentGroup, a.index, r.commands);
  return Ln(n, a.segmentGroup, s, o, e);
}
function Oi(i) {
  return typeof i == 'object' && i != null && !i.outlets && !i.segmentPath;
}
function We(i) {
  return typeof i == 'object' && i != null && i.outlets;
}
function Ln(i, t, o, e, n) {
  let r = {};
  e &&
    Object.entries(e).forEach(([c, d]) => {
      r[c] = Array.isArray(d) ? d.map((l) => `${l}`) : `${d}`;
    });
  let a;
  i === t ? (a = o) : (a = ma(i, t, o));
  let s = da(la(a));
  return new jt(s, r, n);
}
function ma(i, t, o) {
  let e = {};
  return (
    Object.entries(i.children).forEach(([n, r]) => {
      r === t ? (e[n] = o) : (e[n] = ma(r, t, o));
    }),
    new E(i.segments, e)
  );
}
var Ni = class {
  constructor(t, o, e) {
    if (
      ((this.isAbsolute = t),
      (this.numberOfDoubleDots = o),
      (this.commands = e),
      t && e.length > 0 && Oi(e[0]))
    )
      throw new M(4003, !1);
    let n = e.find(We);
    if (n && n !== ia(e)) throw new M(4004, !1);
  }
  toRoot() {
    return (
      this.isAbsolute && this.commands.length === 1 && this.commands[0] == '/'
    );
  }
};
function Cc(i) {
  if (typeof i[0] == 'string' && i.length === 1 && i[0] === '/')
    return new Ni(!0, 0, i);
  let t = 0,
    o = !1,
    e = i.reduce((n, r, a) => {
      if (typeof r == 'object' && r != null) {
        if (r.outlets) {
          let s = {};
          return (
            Object.entries(r.outlets).forEach(([c, d]) => {
              s[c] = typeof d == 'string' ? d.split('/') : d;
            }),
            [...n, { outlets: s }]
          );
        }
        if (r.segmentPath) return [...n, r.segmentPath];
      }
      return typeof r != 'string'
        ? [...n, r]
        : a === 0
          ? (r.split('/').forEach((s, c) => {
              (c == 0 && s === '.') ||
                (c == 0 && s === ''
                  ? (o = !0)
                  : s === '..'
                    ? t++
                    : s != '' && n.push(s));
            }),
            n)
          : [...n, r];
    }, []);
  return new Ni(o, t, e);
}
var ue = class {
  constructor(t, o, e) {
    (this.segmentGroup = t), (this.processChildren = o), (this.index = e);
  }
};
function Ic(i, t, o) {
  if (i.isAbsolute) return new ue(t, !0, 0);
  if (!o) return new ue(t, !1, NaN);
  if (o.parent === null) return new ue(o, !0, 0);
  let e = Oi(i.commands[0]) ? 0 : 1,
    n = o.segments.length - 1 + e;
  return Ec(o, n, i.numberOfDoubleDots);
}
function Ec(i, t, o) {
  let e = i,
    n = t,
    r = o;
  for (; r > n; ) {
    if (((r -= n), (e = e.parent), !e)) throw new M(4005, !1);
    n = e.segments.length;
  }
  return new ue(e, !1, n - r);
}
function Dc(i) {
  return We(i[0]) ? i[0].outlets : { [y]: i };
}
function pa(i, t, o) {
  if (((i ??= new E([], {})), i.segments.length === 0 && i.hasChildren()))
    return He(i, t, o);
  let e = Ac(i, t, o),
    n = o.slice(e.commandIndex);
  if (e.match && e.pathIndex < i.segments.length) {
    let r = new E(i.segments.slice(0, e.pathIndex), {});
    return (
      (r.children[y] = new E(i.segments.slice(e.pathIndex), i.children)),
      He(r, 0, n)
    );
  } else
    return e.match && n.length === 0
      ? new E(i.segments, {})
      : e.match && !i.hasChildren()
        ? qn(i, t, o)
        : e.match
          ? He(i, 0, n)
          : qn(i, t, o);
}
function He(i, t, o) {
  if (o.length === 0) return new E(i.segments, {});
  {
    let e = Dc(o),
      n = {};
    if (
      Object.keys(e).some((r) => r !== y) &&
      i.children[y] &&
      i.numberOfChildren === 1 &&
      i.children[y].segments.length === 0
    ) {
      let r = He(i.children[y], t, o);
      return new E(i.segments, r.children);
    }
    return (
      Object.entries(e).forEach(([r, a]) => {
        typeof a == 'string' && (a = [a]),
          a !== null && (n[r] = pa(i.children[r], t, a));
      }),
      Object.entries(i.children).forEach(([r, a]) => {
        e[r] === void 0 && (n[r] = a);
      }),
      new E(i.segments, n)
    );
  }
}
function Ac(i, t, o) {
  let e = 0,
    n = t,
    r = { match: !1, pathIndex: 0, commandIndex: 0 };
  for (; n < i.segments.length; ) {
    if (e >= o.length) return r;
    let a = i.segments[n],
      s = o[e];
    if (We(s)) break;
    let c = `${s}`,
      d = e < o.length - 1 ? o[e + 1] : null;
    if (n > 0 && c === void 0) break;
    if (c && d && typeof d == 'object' && d.outlets === void 0) {
      if (!Jr(c, d, a)) return r;
      e += 2;
    } else {
      if (!Jr(c, {}, a)) return r;
      e++;
    }
    n++;
  }
  return { match: !0, pathIndex: n, commandIndex: e };
}
function qn(i, t, o) {
  let e = i.segments.slice(0, t),
    n = 0;
  for (; n < o.length; ) {
    let r = o[n];
    if (We(r)) {
      let c = Mc(r.outlets);
      return new E(e, c);
    }
    if (n === 0 && Oi(o[0])) {
      let c = i.segments[t];
      e.push(new Qt(c.path, Xr(o[0]))), n++;
      continue;
    }
    let a = We(r) ? r.outlets[y] : `${r}`,
      s = n < o.length - 1 ? o[n + 1] : null;
    a && s && Oi(s)
      ? (e.push(new Qt(a, Xr(s))), (n += 2))
      : (e.push(new Qt(a, {})), n++);
  }
  return new E(e, {});
}
function Mc(i) {
  let t = {};
  return (
    Object.entries(i).forEach(([o, e]) => {
      typeof e == 'string' && (e = [e]),
        e !== null && (t[o] = qn(new E([], {}), 0, e));
    }),
    t
  );
}
function Xr(i) {
  let t = {};
  return Object.entries(i).forEach(([o, e]) => (t[o] = `${e}`)), t;
}
function Jr(i, t, o) {
  return i == o.path && kt(t, o.parameters);
}
var Ge = 'imperative',
  B = (function (i) {
    return (
      (i[(i.NavigationStart = 0)] = 'NavigationStart'),
      (i[(i.NavigationEnd = 1)] = 'NavigationEnd'),
      (i[(i.NavigationCancel = 2)] = 'NavigationCancel'),
      (i[(i.NavigationError = 3)] = 'NavigationError'),
      (i[(i.RoutesRecognized = 4)] = 'RoutesRecognized'),
      (i[(i.ResolveStart = 5)] = 'ResolveStart'),
      (i[(i.ResolveEnd = 6)] = 'ResolveEnd'),
      (i[(i.GuardsCheckStart = 7)] = 'GuardsCheckStart'),
      (i[(i.GuardsCheckEnd = 8)] = 'GuardsCheckEnd'),
      (i[(i.RouteConfigLoadStart = 9)] = 'RouteConfigLoadStart'),
      (i[(i.RouteConfigLoadEnd = 10)] = 'RouteConfigLoadEnd'),
      (i[(i.ChildActivationStart = 11)] = 'ChildActivationStart'),
      (i[(i.ChildActivationEnd = 12)] = 'ChildActivationEnd'),
      (i[(i.ActivationStart = 13)] = 'ActivationStart'),
      (i[(i.ActivationEnd = 14)] = 'ActivationEnd'),
      (i[(i.Scroll = 15)] = 'Scroll'),
      (i[(i.NavigationSkipped = 16)] = 'NavigationSkipped'),
      i
    );
  })(B || {}),
  ft = class {
    constructor(t, o) {
      (this.id = t), (this.url = o);
    }
  },
  Ke = class extends ft {
    constructor(t, o, e = 'imperative', n = null) {
      super(t, o),
        (this.type = B.NavigationStart),
        (this.navigationTrigger = e),
        (this.restoredState = n);
    }
    toString() {
      return `NavigationStart(id: ${this.id}, url: '${this.url}')`;
    }
  },
  Xt = class extends ft {
    constructor(t, o, e) {
      super(t, o), (this.urlAfterRedirects = e), (this.type = B.NavigationEnd);
    }
    toString() {
      return `NavigationEnd(id: ${this.id}, url: '${this.url}', urlAfterRedirects: '${this.urlAfterRedirects}')`;
    }
  },
  ct = (function (i) {
    return (
      (i[(i.Redirect = 0)] = 'Redirect'),
      (i[(i.SupersededByNewNavigation = 1)] = 'SupersededByNewNavigation'),
      (i[(i.NoDataFromResolver = 2)] = 'NoDataFromResolver'),
      (i[(i.GuardRejected = 3)] = 'GuardRejected'),
      i
    );
  })(ct || {}),
  Wn = (function (i) {
    return (
      (i[(i.IgnoredSameUrlNavigation = 0)] = 'IgnoredSameUrlNavigation'),
      (i[(i.IgnoredByUrlHandlingStrategy = 1)] =
        'IgnoredByUrlHandlingStrategy'),
      i
    );
  })(Wn || {}),
  Lt = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.reason = e),
        (this.code = n),
        (this.type = B.NavigationCancel);
    }
    toString() {
      return `NavigationCancel(id: ${this.id}, url: '${this.url}')`;
    }
  },
  Jt = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.reason = e),
        (this.code = n),
        (this.type = B.NavigationSkipped);
    }
  },
  Ze = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.error = e),
        (this.target = n),
        (this.type = B.NavigationError);
    }
    toString() {
      return `NavigationError(id: ${this.id}, url: '${this.url}', error: ${this.error})`;
    }
  },
  Pi = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.urlAfterRedirects = e),
        (this.state = n),
        (this.type = B.RoutesRecognized);
    }
    toString() {
      return `RoutesRecognized(id: ${this.id}, url: '${this.url}', urlAfterRedirects: '${this.urlAfterRedirects}', state: ${this.state})`;
    }
  },
  Kn = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.urlAfterRedirects = e),
        (this.state = n),
        (this.type = B.GuardsCheckStart);
    }
    toString() {
      return `GuardsCheckStart(id: ${this.id}, url: '${this.url}', urlAfterRedirects: '${this.urlAfterRedirects}', state: ${this.state})`;
    }
  },
  Zn = class extends ft {
    constructor(t, o, e, n, r) {
      super(t, o),
        (this.urlAfterRedirects = e),
        (this.state = n),
        (this.shouldActivate = r),
        (this.type = B.GuardsCheckEnd);
    }
    toString() {
      return `GuardsCheckEnd(id: ${this.id}, url: '${this.url}', urlAfterRedirects: '${this.urlAfterRedirects}', state: ${this.state}, shouldActivate: ${this.shouldActivate})`;
    }
  },
  Qn = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.urlAfterRedirects = e),
        (this.state = n),
        (this.type = B.ResolveStart);
    }
    toString() {
      return `ResolveStart(id: ${this.id}, url: '${this.url}', urlAfterRedirects: '${this.urlAfterRedirects}', state: ${this.state})`;
    }
  },
  Yn = class extends ft {
    constructor(t, o, e, n) {
      super(t, o),
        (this.urlAfterRedirects = e),
        (this.state = n),
        (this.type = B.ResolveEnd);
    }
    toString() {
      return `ResolveEnd(id: ${this.id}, url: '${this.url}', urlAfterRedirects: '${this.urlAfterRedirects}', state: ${this.state})`;
    }
  },
  Xn = class {
    constructor(t) {
      (this.route = t), (this.type = B.RouteConfigLoadStart);
    }
    toString() {
      return `RouteConfigLoadStart(path: ${this.route.path})`;
    }
  },
  Jn = class {
    constructor(t) {
      (this.route = t), (this.type = B.RouteConfigLoadEnd);
    }
    toString() {
      return `RouteConfigLoadEnd(path: ${this.route.path})`;
    }
  },
  to = class {
    constructor(t) {
      (this.snapshot = t), (this.type = B.ChildActivationStart);
    }
    toString() {
      return `ChildActivationStart(path: '${(this.snapshot.routeConfig && this.snapshot.routeConfig.path) || ''}')`;
    }
  },
  eo = class {
    constructor(t) {
      (this.snapshot = t), (this.type = B.ChildActivationEnd);
    }
    toString() {
      return `ChildActivationEnd(path: '${(this.snapshot.routeConfig && this.snapshot.routeConfig.path) || ''}')`;
    }
  },
  io = class {
    constructor(t) {
      (this.snapshot = t), (this.type = B.ActivationStart);
    }
    toString() {
      return `ActivationStart(path: '${(this.snapshot.routeConfig && this.snapshot.routeConfig.path) || ''}')`;
    }
  },
  no = class {
    constructor(t) {
      (this.snapshot = t), (this.type = B.ActivationEnd);
    }
    toString() {
      return `ActivationEnd(path: '${(this.snapshot.routeConfig && this.snapshot.routeConfig.path) || ''}')`;
    }
  };
var Qe = class {},
  Ye = class {
    constructor(t) {
      this.url = t;
    }
  };
var oo = class {
    constructor() {
      (this.outlet = null),
        (this.route = null),
        (this.injector = null),
        (this.children = new Bi()),
        (this.attachRef = null);
    }
  },
  Bi = (() => {
    let t = class t {
      constructor() {
        this.contexts = new Map();
      }
      onChildOutletCreated(e, n) {
        let r = this.getOrCreateContext(e);
        (r.outlet = n), this.contexts.set(e, r);
      }
      onChildOutletDestroyed(e) {
        let n = this.getContext(e);
        n && ((n.outlet = null), (n.attachRef = null));
      }
      onOutletDeactivated() {
        let e = this.contexts;
        return (this.contexts = new Map()), e;
      }
      onOutletReAttached(e) {
        this.contexts = e;
      }
      getOrCreateContext(e) {
        let n = this.getContext(e);
        return n || ((n = new oo()), this.contexts.set(e, n)), n;
      }
      getContext(e) {
        return this.contexts.get(e) || null;
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Vi = class {
    constructor(t) {
      this._root = t;
    }
    get root() {
      return this._root.value;
    }
    parent(t) {
      let o = this.pathFromRoot(t);
      return o.length > 1 ? o[o.length - 2] : null;
    }
    children(t) {
      let o = ro(t, this._root);
      return o ? o.children.map((e) => e.value) : [];
    }
    firstChild(t) {
      let o = ro(t, this._root);
      return o && o.children.length > 0 ? o.children[0].value : null;
    }
    siblings(t) {
      let o = ao(t, this._root);
      return o.length < 2
        ? []
        : o[o.length - 2].children.map((n) => n.value).filter((n) => n !== t);
    }
    pathFromRoot(t) {
      return ao(t, this._root).map((o) => o.value);
    }
  };
function ro(i, t) {
  if (i === t.value) return t;
  for (let o of t.children) {
    let e = ro(i, o);
    if (e) return e;
  }
  return null;
}
function ao(i, t) {
  if (i === t.value) return [t];
  for (let o of t.children) {
    let e = ao(i, o);
    if (e.length) return e.unshift(t), e;
  }
  return [];
}
var st = class {
  constructor(t, o) {
    (this.value = t), (this.children = o);
  }
  toString() {
    return `TreeNode(${this.value})`;
  }
};
function le(i) {
  let t = {};
  return i && i.children.forEach((o) => (t[o.value.outlet] = o)), t;
}
var ji = class extends Vi {
  constructor(t, o) {
    super(t), (this.snapshot = o), vo(this, t);
  }
  toString() {
    return this.snapshot.toString();
  }
};
function fa(i) {
  let t = Tc(i),
    o = new X([new Qt('', {})]),
    e = new X({}),
    n = new X({}),
    r = new X({}),
    a = new X(''),
    s = new fe(o, e, r, a, n, y, i, t.root);
  return (s.snapshot = t.root), new ji(new st(s, []), t);
}
function Tc(i) {
  let t = {},
    o = {},
    e = {},
    n = '',
    r = new Xe([], t, e, n, o, y, i, null, {});
  return new Li('', new st(r, []));
}
var fe = class {
  constructor(t, o, e, n, r, a, s, c) {
    (this.urlSubject = t),
      (this.paramsSubject = o),
      (this.queryParamsSubject = e),
      (this.fragmentSubject = n),
      (this.dataSubject = r),
      (this.outlet = a),
      (this.component = s),
      (this._futureSnapshot = c),
      (this.title = this.dataSubject?.pipe(x((d) => d[ei])) ?? b(void 0)),
      (this.url = t),
      (this.params = o),
      (this.queryParams = e),
      (this.fragment = n),
      (this.data = r);
  }
  get routeConfig() {
    return this._futureSnapshot.routeConfig;
  }
  get root() {
    return this._routerState.root;
  }
  get parent() {
    return this._routerState.parent(this);
  }
  get firstChild() {
    return this._routerState.firstChild(this);
  }
  get children() {
    return this._routerState.children(this);
  }
  get pathFromRoot() {
    return this._routerState.pathFromRoot(this);
  }
  get paramMap() {
    return (
      (this._paramMap ??= this.params.pipe(x((t) => me(t)))), this._paramMap
    );
  }
  get queryParamMap() {
    return (
      (this._queryParamMap ??= this.queryParams.pipe(x((t) => me(t)))),
      this._queryParamMap
    );
  }
  toString() {
    return this.snapshot
      ? this.snapshot.toString()
      : `Future(${this._futureSnapshot})`;
  }
};
function go(i, t, o = 'emptyOnly') {
  let e,
    { routeConfig: n } = i;
  return (
    t !== null &&
    (o === 'always' ||
      n?.path === '' ||
      (!t.component && !t.routeConfig?.loadComponent))
      ? (e = {
          params: u(u({}, t.params), i.params),
          data: u(u({}, t.data), i.data),
          resolve: u(u(u(u({}, i.data), t.data), n?.data), i._resolvedData),
        })
      : (e = {
          params: u({}, i.params),
          data: u({}, i.data),
          resolve: u(u({}, i.data), i._resolvedData ?? {}),
        }),
    n && ga(n) && (e.resolve[ei] = n.title),
    e
  );
}
var Xe = class {
    get title() {
      return this.data?.[ei];
    }
    constructor(t, o, e, n, r, a, s, c, d) {
      (this.url = t),
        (this.params = o),
        (this.queryParams = e),
        (this.fragment = n),
        (this.data = r),
        (this.outlet = a),
        (this.component = s),
        (this.routeConfig = c),
        (this._resolve = d);
    }
    get root() {
      return this._routerState.root;
    }
    get parent() {
      return this._routerState.parent(this);
    }
    get firstChild() {
      return this._routerState.firstChild(this);
    }
    get children() {
      return this._routerState.children(this);
    }
    get pathFromRoot() {
      return this._routerState.pathFromRoot(this);
    }
    get paramMap() {
      return (this._paramMap ??= me(this.params)), this._paramMap;
    }
    get queryParamMap() {
      return (
        (this._queryParamMap ??= me(this.queryParams)), this._queryParamMap
      );
    }
    toString() {
      let t = this.url.map((e) => e.toString()).join('/'),
        o = this.routeConfig ? this.routeConfig.path : '';
      return `Route(url:'${t}', path:'${o}')`;
    }
  },
  Li = class extends Vi {
    constructor(t, o) {
      super(o), (this.url = t), vo(this, o);
    }
    toString() {
      return ba(this._root);
    }
  };
function vo(i, t) {
  (t.value._routerState = i), t.children.forEach((o) => vo(i, o));
}
function ba(i) {
  let t = i.children.length > 0 ? ` { ${i.children.map(ba).join(', ')} } ` : '';
  return `${i.value}${t}`;
}
function Un(i) {
  if (i.snapshot) {
    let t = i.snapshot,
      o = i._futureSnapshot;
    (i.snapshot = o),
      kt(t.queryParams, o.queryParams) ||
        i.queryParamsSubject.next(o.queryParams),
      t.fragment !== o.fragment && i.fragmentSubject.next(o.fragment),
      kt(t.params, o.params) || i.paramsSubject.next(o.params),
      rc(t.url, o.url) || i.urlSubject.next(o.url),
      kt(t.data, o.data) || i.dataSubject.next(o.data);
  } else
    (i.snapshot = i._futureSnapshot),
      i.dataSubject.next(i._futureSnapshot.data);
}
function so(i, t) {
  let o = kt(i.params, t.params) && dc(i.url, t.url),
    e = !i.parent != !t.parent;
  return o && !e && (!i.parent || so(i.parent, t.parent));
}
function ga(i) {
  return typeof i.title == 'string' || i.title === null;
}
var Sc = (() => {
    let t = class t {
      constructor() {
        (this.activated = null),
          (this._activatedRoute = null),
          (this.name = y),
          (this.activateEvents = new Q()),
          (this.deactivateEvents = new Q()),
          (this.attachEvents = new Q()),
          (this.detachEvents = new Q()),
          (this.parentContexts = h(Bi)),
          (this.location = h(ur)),
          (this.changeDetector = h(xt)),
          (this.environmentInjector = h(Ee)),
          (this.inputBinder = h(_o, { optional: !0 })),
          (this.supportsBindingToComponentInputs = !0);
      }
      get activatedComponentRef() {
        return this.activated;
      }
      ngOnChanges(e) {
        if (e.name) {
          let { firstChange: n, previousValue: r } = e.name;
          if (n) return;
          this.isTrackedInParentContexts(r) &&
            (this.deactivate(), this.parentContexts.onChildOutletDestroyed(r)),
            this.initializeOutletWithName();
        }
      }
      ngOnDestroy() {
        this.isTrackedInParentContexts(this.name) &&
          this.parentContexts.onChildOutletDestroyed(this.name),
          this.inputBinder?.unsubscribeFromRouteData(this);
      }
      isTrackedInParentContexts(e) {
        return this.parentContexts.getContext(e)?.outlet === this;
      }
      ngOnInit() {
        this.initializeOutletWithName();
      }
      initializeOutletWithName() {
        if (
          (this.parentContexts.onChildOutletCreated(this.name, this),
          this.activated)
        )
          return;
        let e = this.parentContexts.getContext(this.name);
        e?.route &&
          (e.attachRef
            ? this.attach(e.attachRef, e.route)
            : this.activateWith(e.route, e.injector));
      }
      get isActivated() {
        return !!this.activated;
      }
      get component() {
        if (!this.activated) throw new M(4012, !1);
        return this.activated.instance;
      }
      get activatedRoute() {
        if (!this.activated) throw new M(4012, !1);
        return this._activatedRoute;
      }
      get activatedRouteData() {
        return this._activatedRoute ? this._activatedRoute.snapshot.data : {};
      }
      detach() {
        if (!this.activated) throw new M(4012, !1);
        this.location.detach();
        let e = this.activated;
        return (
          (this.activated = null),
          (this._activatedRoute = null),
          this.detachEvents.emit(e.instance),
          e
        );
      }
      attach(e, n) {
        (this.activated = e),
          (this._activatedRoute = n),
          this.location.insert(e.hostView),
          this.inputBinder?.bindActivatedRouteToOutletComponent(this),
          this.attachEvents.emit(e.instance);
      }
      deactivate() {
        if (this.activated) {
          let e = this.component;
          this.activated.destroy(),
            (this.activated = null),
            (this._activatedRoute = null),
            this.deactivateEvents.emit(e);
        }
      }
      activateWith(e, n) {
        if (this.isActivated) throw new M(4013, !1);
        this._activatedRoute = e;
        let r = this.location,
          s = e.snapshot.component,
          c = this.parentContexts.getOrCreateContext(this.name).children,
          d = new co(e, c, r.injector);
        (this.activated = r.createComponent(s, {
          index: r.length,
          injector: d,
          environmentInjector: n ?? this.environmentInjector,
        })),
          this.changeDetector.markForCheck(),
          this.inputBinder?.bindActivatedRouteToOutletComponent(this),
          this.activateEvents.emit(this.activated.instance);
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵdir = mt({
        type: t,
        selectors: [['router-outlet']],
        inputs: { name: 'name' },
        outputs: {
          activateEvents: 'activate',
          deactivateEvents: 'deactivate',
          attachEvents: 'attach',
          detachEvents: 'detach',
        },
        exportAs: ['outlet'],
        standalone: !0,
        features: [re],
      }));
    let i = t;
    return i;
  })(),
  co = class i {
    __ngOutletInjector(t) {
      return new i(this.route, this.childContexts, t);
    }
    constructor(t, o, e) {
      (this.route = t), (this.childContexts = o), (this.parent = e);
    }
    get(t, o) {
      return t === fe
        ? this.route
        : t === Bi
          ? this.childContexts
          : this.parent.get(t, o);
    }
  },
  _o = new C('');
function Rc(i, t, o) {
  let e = Je(i, t._root, o ? o._root : void 0);
  return new ji(e, t);
}
function Je(i, t, o) {
  if (o && i.shouldReuseRoute(t.value, o.value.snapshot)) {
    let e = o.value;
    e._futureSnapshot = t.value;
    let n = Fc(i, t, o);
    return new st(e, n);
  } else {
    if (i.shouldAttach(t.value)) {
      let r = i.retrieve(t.value);
      if (r !== null) {
        let a = r.route;
        return (
          (a.value._futureSnapshot = t.value),
          (a.children = t.children.map((s) => Je(i, s))),
          a
        );
      }
    }
    let e = Oc(t.value),
      n = t.children.map((r) => Je(i, r));
    return new st(e, n);
  }
}
function Fc(i, t, o) {
  return t.children.map((e) => {
    for (let n of o.children)
      if (i.shouldReuseRoute(e.value, n.value.snapshot)) return Je(i, e, n);
    return Je(i, e);
  });
}
function Oc(i) {
  return new fe(
    new X(i.url),
    new X(i.params),
    new X(i.queryParams),
    new X(i.fragment),
    new X(i.data),
    i.outlet,
    i.component,
    i
  );
}
var va = 'ngNavigationCancelingError';
function _a(i, t) {
  let { redirectTo: o, navigationBehaviorOptions: e } = pe(t)
      ? { redirectTo: t, navigationBehaviorOptions: void 0 }
      : t,
    n = ya(!1, ct.Redirect);
  return (n.url = o), (n.navigationBehaviorOptions = e), n;
}
function ya(i, t) {
  let o = new Error(`NavigationCancelingError: ${i || ''}`);
  return (o[va] = !0), (o.cancellationCode = t), o;
}
function Nc(i) {
  return xa(i) && pe(i.url);
}
function xa(i) {
  return !!i && i[va];
}
var Pc = (() => {
  let t = class t {};
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵcmp = P({
      type: t,
      selectors: [['ng-component']],
      standalone: !0,
      features: [j],
      decls: 1,
      vars: 0,
      template: function (n, r) {
        n & 1 && F(0, 'router-outlet');
      },
      dependencies: [Sc],
      encapsulation: 2,
    }));
  let i = t;
  return i;
})();
function Vc(i, t) {
  return (
    i.providers &&
      !i._injector &&
      (i._injector = mr(i.providers, t, `Route: ${i.path}`)),
    i._injector ?? t
  );
}
function yo(i) {
  let t = i.children && i.children.map(yo),
    o = t ? U(u({}, i), { children: t }) : u({}, i);
  return (
    !o.component &&
      !o.loadComponent &&
      (t || o.loadChildren) &&
      o.outlet &&
      o.outlet !== y &&
      (o.component = Pc),
    o
  );
}
function Ct(i) {
  return i.outlet || y;
}
function jc(i, t) {
  let o = i.filter((e) => Ct(e) === t);
  return o.push(...i.filter((e) => Ct(e) !== t)), o;
}
function ii(i) {
  if (!i) return null;
  if (i.routeConfig?._injector) return i.routeConfig._injector;
  for (let t = i.parent; t; t = t.parent) {
    let o = t.routeConfig;
    if (o?._loadedInjector) return o._loadedInjector;
    if (o?._injector) return o._injector;
  }
  return null;
}
var Lc = (i, t, o, e) =>
    x(
      (n) => (
        new lo(t, n.targetRouterState, n.currentRouterState, o, e).activate(i),
        n
      )
    ),
  lo = class {
    constructor(t, o, e, n, r) {
      (this.routeReuseStrategy = t),
        (this.futureState = o),
        (this.currState = e),
        (this.forwardEvent = n),
        (this.inputBindingEnabled = r);
    }
    activate(t) {
      let o = this.futureState._root,
        e = this.currState ? this.currState._root : null;
      this.deactivateChildRoutes(o, e, t),
        Un(this.futureState.root),
        this.activateChildRoutes(o, e, t);
    }
    deactivateChildRoutes(t, o, e) {
      let n = le(o);
      t.children.forEach((r) => {
        let a = r.value.outlet;
        this.deactivateRoutes(r, n[a], e), delete n[a];
      }),
        Object.values(n).forEach((r) => {
          this.deactivateRouteAndItsChildren(r, e);
        });
    }
    deactivateRoutes(t, o, e) {
      let n = t.value,
        r = o ? o.value : null;
      if (n === r)
        if (n.component) {
          let a = e.getContext(n.outlet);
          a && this.deactivateChildRoutes(t, o, a.children);
        } else this.deactivateChildRoutes(t, o, e);
      else r && this.deactivateRouteAndItsChildren(o, e);
    }
    deactivateRouteAndItsChildren(t, o) {
      t.value.component &&
      this.routeReuseStrategy.shouldDetach(t.value.snapshot)
        ? this.detachAndStoreRouteSubtree(t, o)
        : this.deactivateRouteAndOutlet(t, o);
    }
    detachAndStoreRouteSubtree(t, o) {
      let e = o.getContext(t.value.outlet),
        n = e && t.value.component ? e.children : o,
        r = le(t);
      for (let a of Object.values(r)) this.deactivateRouteAndItsChildren(a, n);
      if (e && e.outlet) {
        let a = e.outlet.detach(),
          s = e.children.onOutletDeactivated();
        this.routeReuseStrategy.store(t.value.snapshot, {
          componentRef: a,
          route: t,
          contexts: s,
        });
      }
    }
    deactivateRouteAndOutlet(t, o) {
      let e = o.getContext(t.value.outlet),
        n = e && t.value.component ? e.children : o,
        r = le(t);
      for (let a of Object.values(r)) this.deactivateRouteAndItsChildren(a, n);
      e &&
        (e.outlet && (e.outlet.deactivate(), e.children.onOutletDeactivated()),
        (e.attachRef = null),
        (e.route = null));
    }
    activateChildRoutes(t, o, e) {
      let n = le(o);
      t.children.forEach((r) => {
        this.activateRoutes(r, n[r.value.outlet], e),
          this.forwardEvent(new no(r.value.snapshot));
      }),
        t.children.length && this.forwardEvent(new eo(t.value.snapshot));
    }
    activateRoutes(t, o, e) {
      let n = t.value,
        r = o ? o.value : null;
      if ((Un(n), n === r))
        if (n.component) {
          let a = e.getOrCreateContext(n.outlet);
          this.activateChildRoutes(t, o, a.children);
        } else this.activateChildRoutes(t, o, e);
      else if (n.component) {
        let a = e.getOrCreateContext(n.outlet);
        if (this.routeReuseStrategy.shouldAttach(n.snapshot)) {
          let s = this.routeReuseStrategy.retrieve(n.snapshot);
          this.routeReuseStrategy.store(n.snapshot, null),
            a.children.onOutletReAttached(s.contexts),
            (a.attachRef = s.componentRef),
            (a.route = s.route.value),
            a.outlet && a.outlet.attach(s.componentRef, s.route.value),
            Un(s.route.value),
            this.activateChildRoutes(t, null, a.children);
        } else {
          let s = ii(n.snapshot);
          (a.attachRef = null),
            (a.route = n),
            (a.injector = s),
            a.outlet && a.outlet.activateWith(n, a.injector),
            this.activateChildRoutes(t, null, a.children);
        }
      } else this.activateChildRoutes(t, null, e);
    }
  },
  Ui = class {
    constructor(t) {
      (this.path = t), (this.route = this.path[this.path.length - 1]);
    }
  },
  he = class {
    constructor(t, o) {
      (this.component = t), (this.route = o);
    }
  };
function Uc(i, t, o) {
  let e = i._root,
    n = t ? t._root : null;
  return Be(e, n, o, [e.value]);
}
function zc(i) {
  let t = i.routeConfig ? i.routeConfig.canActivateChild : null;
  return !t || t.length === 0 ? null : { node: i, guards: t };
}
function ge(i, t) {
  let o = Symbol(),
    e = t.get(i, o);
  return e === o ? (typeof i == 'function' && !Xo(i) ? i : t.get(i)) : e;
}
function Be(
  i,
  t,
  o,
  e,
  n = { canDeactivateChecks: [], canActivateChecks: [] }
) {
  let r = le(t);
  return (
    i.children.forEach((a) => {
      Bc(a, r[a.value.outlet], o, e.concat([a.value]), n),
        delete r[a.value.outlet];
    }),
    Object.entries(r).forEach(([a, s]) => qe(s, o.getContext(a), n)),
    n
  );
}
function Bc(
  i,
  t,
  o,
  e,
  n = { canDeactivateChecks: [], canActivateChecks: [] }
) {
  let r = i.value,
    a = t ? t.value : null,
    s = o ? o.getContext(i.value.outlet) : null;
  if (a && r.routeConfig === a.routeConfig) {
    let c = $c(a, r, r.routeConfig.runGuardsAndResolvers);
    c
      ? n.canActivateChecks.push(new Ui(e))
      : ((r.data = a.data), (r._resolvedData = a._resolvedData)),
      r.component ? Be(i, t, s ? s.children : null, e, n) : Be(i, t, o, e, n),
      c &&
        s &&
        s.outlet &&
        s.outlet.isActivated &&
        n.canDeactivateChecks.push(new he(s.outlet.component, a));
  } else
    a && qe(t, s, n),
      n.canActivateChecks.push(new Ui(e)),
      r.component
        ? Be(i, null, s ? s.children : null, e, n)
        : Be(i, null, o, e, n);
  return n;
}
function $c(i, t, o) {
  if (typeof o == 'function') return o(i, t);
  switch (o) {
    case 'pathParamsChange':
      return !Yt(i.url, t.url);
    case 'pathParamsOrQueryParamsChange':
      return !Yt(i.url, t.url) || !kt(i.queryParams, t.queryParams);
    case 'always':
      return !0;
    case 'paramsOrQueryParamsChange':
      return !so(i, t) || !kt(i.queryParams, t.queryParams);
    case 'paramsChange':
    default:
      return !so(i, t);
  }
}
function qe(i, t, o) {
  let e = le(i),
    n = i.value;
  Object.entries(e).forEach(([r, a]) => {
    n.component
      ? t
        ? qe(a, t.children.getContext(r), o)
        : qe(a, null, o)
      : qe(a, t, o);
  }),
    n.component
      ? t && t.outlet && t.outlet.isActivated
        ? o.canDeactivateChecks.push(new he(t.outlet.component, n))
        : o.canDeactivateChecks.push(new he(null, n))
      : o.canDeactivateChecks.push(new he(null, n));
}
function ni(i) {
  return typeof i == 'function';
}
function Hc(i) {
  return typeof i == 'boolean';
}
function Gc(i) {
  return i && ni(i.canLoad);
}
function qc(i) {
  return i && ni(i.canActivate);
}
function Wc(i) {
  return i && ni(i.canActivateChild);
}
function Kc(i) {
  return i && ni(i.canDeactivate);
}
function Zc(i) {
  return i && ni(i.canMatch);
}
function wa(i) {
  return i instanceof Go || i?.name === 'EmptyError';
}
var Mi = Symbol('INITIAL_VALUE');
function be() {
  return _t((i) =>
    Ce(i.map((t) => t.pipe(vt(1), di(Mi)))).pipe(
      x((t) => {
        for (let o of t)
          if (o !== !0) {
            if (o === Mi) return Mi;
            if (o === !1 || o instanceof jt) return o;
          }
        return !0;
      }),
      It((t) => t !== Mi),
      vt(1)
    )
  );
}
function Qc(i, t) {
  return ht((o) => {
    let {
      targetSnapshot: e,
      currentSnapshot: n,
      guards: { canActivateChecks: r, canDeactivateChecks: a },
    } = o;
    return a.length === 0 && r.length === 0
      ? b(U(u({}, o), { guardsResult: !0 }))
      : Yc(a, e, n, i).pipe(
          ht((s) => (s && Hc(s) ? Xc(e, r, i, t) : b(s))),
          x((s) => U(u({}, o), { guardsResult: s }))
        );
  });
}
function Yc(i, t, o, e) {
  return ut(i).pipe(
    ht((n) => nd(n.component, n.route, o, t, e)),
    Rt((n) => n !== !0, !0)
  );
}
function Xc(i, t, o, e) {
  return ut(t).pipe(
    $t((n) =>
      si(
        td(n.route.parent, e),
        Jc(n.route, e),
        id(i, n.path, o),
        ed(i, n.route, o)
      )
    ),
    Rt((n) => n !== !0, !0)
  );
}
function Jc(i, t) {
  return i !== null && t && t(new io(i)), b(!0);
}
function td(i, t) {
  return i !== null && t && t(new to(i)), b(!0);
}
function ed(i, t, o) {
  let e = t.routeConfig ? t.routeConfig.canActivate : null;
  if (!e || e.length === 0) return b(!0);
  let n = e.map((r) =>
    dn(() => {
      let a = ii(t) ?? o,
        s = ge(r, a),
        c = qc(s) ? s.canActivate(t, i) : Ft(a, () => s(t, i));
      return Ut(c).pipe(Rt());
    })
  );
  return b(n).pipe(be());
}
function id(i, t, o) {
  let e = t[t.length - 1],
    r = t
      .slice(0, t.length - 1)
      .reverse()
      .map((a) => zc(a))
      .filter((a) => a !== null)
      .map((a) =>
        dn(() => {
          let s = a.guards.map((c) => {
            let d = ii(a.node) ?? o,
              l = ge(c, d),
              m = Wc(l) ? l.canActivateChild(e, i) : Ft(d, () => l(e, i));
            return Ut(m).pipe(Rt());
          });
          return b(s).pipe(be());
        })
      );
  return b(r).pipe(be());
}
function nd(i, t, o, e, n) {
  let r = t && t.routeConfig ? t.routeConfig.canDeactivate : null;
  if (!r || r.length === 0) return b(!0);
  let a = r.map((s) => {
    let c = ii(t) ?? n,
      d = ge(s, c),
      l = Kc(d) ? d.canDeactivate(i, t, o, e) : Ft(c, () => d(i, t, o, e));
    return Ut(l).pipe(Rt());
  });
  return b(a).pipe(be());
}
function od(i, t, o, e) {
  let n = t.canLoad;
  if (n === void 0 || n.length === 0) return b(!0);
  let r = n.map((a) => {
    let s = ge(a, i),
      c = Gc(s) ? s.canLoad(t, o) : Ft(i, () => s(t, o));
    return Ut(c);
  });
  return b(r).pipe(be(), ka(e));
}
function ka(i) {
  return $o(
    R((t) => {
      if (pe(t)) throw _a(i, t);
    }),
    x((t) => t === !0)
  );
}
function rd(i, t, o, e) {
  let n = t.canMatch;
  if (!n || n.length === 0) return b(!0);
  let r = n.map((a) => {
    let s = ge(a, i),
      c = Zc(s) ? s.canMatch(t, o) : Ft(i, () => s(t, o));
    return Ut(c);
  });
  return b(r).pipe(be(), ka(e));
}
var ti = class {
    constructor(t) {
      this.segmentGroup = t || null;
    }
  },
  zi = class extends Error {
    constructor(t) {
      super(), (this.urlTree = t);
    }
  };
function de(i) {
  return Bt(new ti(i));
}
function ad(i) {
  return Bt(new M(4e3, !1));
}
function sd(i) {
  return Bt(ya(!1, ct.GuardRejected));
}
var uo = class {
    constructor(t, o) {
      (this.urlSerializer = t), (this.urlTree = o);
    }
    lineralizeSegments(t, o) {
      let e = [],
        n = o.root;
      for (;;) {
        if (((e = e.concat(n.segments)), n.numberOfChildren === 0)) return b(e);
        if (n.numberOfChildren > 1 || !n.children[y]) return ad(t.redirectTo);
        n = n.children[y];
      }
    }
    applyRedirectCommands(t, o, e) {
      let n = this.applyRedirectCreateUrlTree(
        o,
        this.urlSerializer.parse(o),
        t,
        e
      );
      if (o.startsWith('/')) throw new zi(n);
      return n;
    }
    applyRedirectCreateUrlTree(t, o, e, n) {
      let r = this.createSegmentGroup(t, o.root, e, n);
      return new jt(
        r,
        this.createQueryParams(o.queryParams, this.urlTree.queryParams),
        o.fragment
      );
    }
    createQueryParams(t, o) {
      let e = {};
      return (
        Object.entries(t).forEach(([n, r]) => {
          if (typeof r == 'string' && r.startsWith(':')) {
            let s = r.substring(1);
            e[n] = o[s];
          } else e[n] = r;
        }),
        e
      );
    }
    createSegmentGroup(t, o, e, n) {
      let r = this.createSegments(t, o.segments, e, n),
        a = {};
      return (
        Object.entries(o.children).forEach(([s, c]) => {
          a[s] = this.createSegmentGroup(t, c, e, n);
        }),
        new E(r, a)
      );
    }
    createSegments(t, o, e, n) {
      return o.map((r) =>
        r.path.startsWith(':')
          ? this.findPosParam(t, r, n)
          : this.findOrReturn(r, e)
      );
    }
    findPosParam(t, o, e) {
      let n = e[o.path.substring(1)];
      if (!n) throw new M(4001, !1);
      return n;
    }
    findOrReturn(t, o) {
      let e = 0;
      for (let n of o) {
        if (n.path === t.path) return o.splice(e), n;
        e++;
      }
      return t;
    }
  },
  ho = {
    matched: !1,
    consumedSegments: [],
    remainingSegments: [],
    parameters: {},
    positionalParamSegments: {},
  };
function cd(i, t, o, e, n) {
  let r = xo(i, t, o);
  return r.matched
    ? ((e = Vc(t, e)),
      rd(e, t, o, n).pipe(x((a) => (a === !0 ? r : u({}, ho)))))
    : b(r);
}
function xo(i, t, o) {
  if (t.path === '**') return dd(o);
  if (t.path === '')
    return t.pathMatch === 'full' && (i.hasChildren() || o.length > 0)
      ? u({}, ho)
      : {
          matched: !0,
          consumedSegments: [],
          remainingSegments: o,
          parameters: {},
          positionalParamSegments: {},
        };
  let n = (t.matcher || oc)(o, i, t);
  if (!n) return u({}, ho);
  let r = {};
  Object.entries(n.posParams ?? {}).forEach(([s, c]) => {
    r[s] = c.path;
  });
  let a =
    n.consumed.length > 0
      ? u(u({}, r), n.consumed[n.consumed.length - 1].parameters)
      : r;
  return {
    matched: !0,
    consumedSegments: n.consumed,
    remainingSegments: o.slice(n.consumed.length),
    parameters: a,
    positionalParamSegments: n.posParams ?? {},
  };
}
function dd(i) {
  return {
    matched: !0,
    parameters: i.length > 0 ? ia(i).parameters : {},
    consumedSegments: i,
    remainingSegments: [],
    positionalParamSegments: {},
  };
}
function ta(i, t, o, e) {
  return o.length > 0 && hd(i, o, e)
    ? {
        segmentGroup: new E(t, ud(e, new E(o, i.children))),
        slicedSegments: [],
      }
    : o.length === 0 && md(i, o, e)
      ? {
          segmentGroup: new E(i.segments, ld(i, o, e, i.children)),
          slicedSegments: o,
        }
      : { segmentGroup: new E(i.segments, i.children), slicedSegments: o };
}
function ld(i, t, o, e) {
  let n = {};
  for (let r of o)
    if ($i(i, t, r) && !e[Ct(r)]) {
      let a = new E([], {});
      n[Ct(r)] = a;
    }
  return u(u({}, e), n);
}
function ud(i, t) {
  let o = {};
  o[y] = t;
  for (let e of i)
    if (e.path === '' && Ct(e) !== y) {
      let n = new E([], {});
      o[Ct(e)] = n;
    }
  return o;
}
function hd(i, t, o) {
  return o.some((e) => $i(i, t, e) && Ct(e) !== y);
}
function md(i, t, o) {
  return o.some((e) => $i(i, t, e));
}
function $i(i, t, o) {
  return (i.hasChildren() || t.length > 0) && o.pathMatch === 'full'
    ? !1
    : o.path === '';
}
function pd(i, t, o, e) {
  return Ct(i) !== e && (e === y || !$i(t, o, i)) ? !1 : xo(t, i, o).matched;
}
function fd(i, t, o) {
  return t.length === 0 && !i.children[o];
}
var mo = class {};
function bd(i, t, o, e, n, r, a = 'emptyOnly') {
  return new po(i, t, o, e, n, a, r).recognize();
}
var gd = 31,
  po = class {
    constructor(t, o, e, n, r, a, s) {
      (this.injector = t),
        (this.configLoader = o),
        (this.rootComponentType = e),
        (this.config = n),
        (this.urlTree = r),
        (this.paramsInheritanceStrategy = a),
        (this.urlSerializer = s),
        (this.applyRedirects = new uo(this.urlSerializer, this.urlTree)),
        (this.absoluteRedirectCount = 0),
        (this.allowRedirects = !0);
    }
    noMatchError(t) {
      return new M(4002, `'${t.segmentGroup}'`);
    }
    recognize() {
      let t = ta(this.urlTree.root, [], [], this.config).segmentGroup;
      return this.match(t).pipe(
        x((o) => {
          let e = new Xe(
              [],
              Object.freeze({}),
              Object.freeze(u({}, this.urlTree.queryParams)),
              this.urlTree.fragment,
              {},
              y,
              this.rootComponentType,
              null,
              {}
            ),
            n = new st(e, o),
            r = new Li('', n),
            a = kc(e, [], this.urlTree.queryParams, this.urlTree.fragment);
          return (
            (a.queryParams = this.urlTree.queryParams),
            (r.url = this.urlSerializer.serialize(a)),
            this.inheritParamsAndData(r._root, null),
            { state: r, tree: a }
          );
        })
      );
    }
    match(t) {
      return this.processSegmentGroup(this.injector, this.config, t, y).pipe(
        St((e) => {
          if (e instanceof zi)
            return (this.urlTree = e.urlTree), this.match(e.urlTree.root);
          throw e instanceof ti ? this.noMatchError(e) : e;
        })
      );
    }
    inheritParamsAndData(t, o) {
      let e = t.value,
        n = go(e, o, this.paramsInheritanceStrategy);
      (e.params = Object.freeze(n.params)),
        (e.data = Object.freeze(n.data)),
        t.children.forEach((r) => this.inheritParamsAndData(r, e));
    }
    processSegmentGroup(t, o, e, n) {
      return e.segments.length === 0 && e.hasChildren()
        ? this.processChildren(t, o, e)
        : this.processSegment(t, o, e, e.segments, n, !0).pipe(
            x((r) => (r instanceof st ? [r] : []))
          );
    }
    processChildren(t, o, e) {
      let n = [];
      for (let r of Object.keys(e.children))
        r === 'primary' ? n.unshift(r) : n.push(r);
      return ut(n).pipe(
        $t((r) => {
          let a = e.children[r],
            s = jc(o, r);
          return this.processSegmentGroup(t, s, a, r);
        }),
        Qo((r, a) => (r.push(...a), r)),
        un(null),
        Zo(),
        ht((r) => {
          if (r === null) return de(e);
          let a = Ca(r);
          return vd(a), b(a);
        })
      );
    }
    processSegment(t, o, e, n, r, a) {
      return ut(o).pipe(
        $t((s) =>
          this.processSegmentAgainstRoute(
            s._injector ?? t,
            o,
            s,
            e,
            n,
            r,
            a
          ).pipe(
            St((c) => {
              if (c instanceof ti) return b(null);
              throw c;
            })
          )
        ),
        Rt((s) => !!s),
        St((s) => {
          if (wa(s)) return fd(e, n, r) ? b(new mo()) : de(e);
          throw s;
        })
      );
    }
    processSegmentAgainstRoute(t, o, e, n, r, a, s) {
      return pd(e, n, r, a)
        ? e.redirectTo === void 0
          ? this.matchSegmentAgainstRoute(t, n, e, r, a)
          : this.allowRedirects && s
            ? this.expandSegmentAgainstRouteUsingRedirect(t, n, o, e, r, a)
            : de(n)
        : de(n);
    }
    expandSegmentAgainstRouteUsingRedirect(t, o, e, n, r, a) {
      let {
        matched: s,
        consumedSegments: c,
        positionalParamSegments: d,
        remainingSegments: l,
      } = xo(o, n, r);
      if (!s) return de(o);
      n.redirectTo.startsWith('/') &&
        (this.absoluteRedirectCount++,
        this.absoluteRedirectCount > gd && (this.allowRedirects = !1));
      let m = this.applyRedirects.applyRedirectCommands(c, n.redirectTo, d);
      return this.applyRedirects
        .lineralizeSegments(n, m)
        .pipe(ht((p) => this.processSegment(t, e, o, p.concat(l), a, !1)));
    }
    matchSegmentAgainstRoute(t, o, e, n, r) {
      let a = cd(o, e, n, t, this.urlSerializer);
      return (
        e.path === '**' && (o.children = {}),
        a.pipe(
          _t((s) =>
            s.matched
              ? ((t = e._injector ?? t),
                this.getChildConfig(t, e, n).pipe(
                  _t(({ routes: c }) => {
                    let d = e._loadedInjector ?? t,
                      {
                        consumedSegments: l,
                        remainingSegments: m,
                        parameters: p,
                      } = s,
                      I = new Xe(
                        l,
                        p,
                        Object.freeze(u({}, this.urlTree.queryParams)),
                        this.urlTree.fragment,
                        yd(e),
                        Ct(e),
                        e.component ?? e._loadedComponent ?? null,
                        e,
                        xd(e)
                      ),
                      { segmentGroup: gt, slicedSegments: Z } = ta(o, l, m, c);
                    if (Z.length === 0 && gt.hasChildren())
                      return this.processChildren(d, c, gt).pipe(
                        x((dt) => (dt === null ? null : new st(I, dt)))
                      );
                    if (c.length === 0 && Z.length === 0)
                      return b(new st(I, []));
                    let At = Ct(e) === r;
                    return this.processSegment(
                      d,
                      c,
                      gt,
                      Z,
                      At ? y : r,
                      !0
                    ).pipe(x((dt) => new st(I, dt instanceof st ? [dt] : [])));
                  })
                ))
              : de(o)
          )
        )
      );
    }
    getChildConfig(t, o, e) {
      return o.children
        ? b({ routes: o.children, injector: t })
        : o.loadChildren
          ? o._loadedRoutes !== void 0
            ? b({ routes: o._loadedRoutes, injector: o._loadedInjector })
            : od(t, o, e, this.urlSerializer).pipe(
                ht((n) =>
                  n
                    ? this.configLoader.loadChildren(t, o).pipe(
                        R((r) => {
                          (o._loadedRoutes = r.routes),
                            (o._loadedInjector = r.injector);
                        })
                      )
                    : sd(o)
                )
              )
          : b({ routes: [], injector: t });
    }
  };
function vd(i) {
  i.sort((t, o) =>
    t.value.outlet === y
      ? -1
      : o.value.outlet === y
        ? 1
        : t.value.outlet.localeCompare(o.value.outlet)
  );
}
function _d(i) {
  let t = i.value.routeConfig;
  return t && t.path === '';
}
function Ca(i) {
  let t = [],
    o = new Set();
  for (let e of i) {
    if (!_d(e)) {
      t.push(e);
      continue;
    }
    let n = t.find((r) => e.value.routeConfig === r.value.routeConfig);
    n !== void 0 ? (n.children.push(...e.children), o.add(n)) : t.push(e);
  }
  for (let e of o) {
    let n = Ca(e.children);
    t.push(new st(e.value, n));
  }
  return t.filter((e) => !o.has(e));
}
function yd(i) {
  return i.data || {};
}
function xd(i) {
  return i.resolve || {};
}
function wd(i, t, o, e, n, r) {
  return ht((a) =>
    bd(i, t, o, e, a.extractedUrl, n, r).pipe(
      x(({ state: s, tree: c }) =>
        U(u({}, a), { targetSnapshot: s, urlAfterRedirects: c })
      )
    )
  );
}
function kd(i, t) {
  return ht((o) => {
    let {
      targetSnapshot: e,
      guards: { canActivateChecks: n },
    } = o;
    if (!n.length) return b(o);
    let r = new Set(n.map((c) => c.route)),
      a = new Set();
    for (let c of r) if (!a.has(c)) for (let d of Ia(c)) a.add(d);
    let s = 0;
    return ut(a).pipe(
      $t((c) =>
        r.has(c)
          ? Cd(c, e, i, t)
          : ((c.data = go(c, c.parent, i).resolve), b(void 0))
      ),
      R(() => s++),
      hn(1),
      ht((c) => (s === a.size ? b(o) : Tt))
    );
  });
}
function Ia(i) {
  let t = i.children.map((o) => Ia(o)).flat();
  return [i, ...t];
}
function Cd(i, t, o, e) {
  let n = i.routeConfig,
    r = i._resolve;
  return (
    n?.title !== void 0 && !ga(n) && (r[ei] = n.title),
    Id(r, i, t, e).pipe(
      x(
        (a) => (
          (i._resolvedData = a), (i.data = go(i, i.parent, o).resolve), null
        )
      )
    )
  );
}
function Id(i, t, o, e) {
  let n = $n(i);
  if (n.length === 0) return b({});
  let r = {};
  return ut(n).pipe(
    ht((a) =>
      Ed(i[a], t, o, e).pipe(
        Rt(),
        R((s) => {
          r[a] = s;
        })
      )
    ),
    hn(1),
    Wo(r),
    St((a) => (wa(a) ? Tt : Bt(a)))
  );
}
function Ed(i, t, o, e) {
  let n = ii(t) ?? e,
    r = ge(i, n),
    a = r.resolve ? r.resolve(t, o) : Ft(n, () => r(t, o));
  return Ut(a);
}
function zn(i) {
  return _t((t) => {
    let o = i(t);
    return o ? ut(o).pipe(x(() => t)) : b(t);
  });
}
var Ea = (() => {
    let t = class t {
      buildTitle(e) {
        let n,
          r = e.root;
        for (; r !== void 0; )
          (n = this.getResolvedTitleForRoute(r) ?? n),
            (r = r.children.find((a) => a.outlet === y));
        return n;
      }
      getResolvedTitleForRoute(e) {
        return e.data[ei];
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: () => h(Dd), providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Dd = (() => {
    let t = class t extends Ea {
      constructor(e) {
        super(), (this.title = e);
      }
      updateTitle(e) {
        let n = this.buildTitle(e);
        n !== void 0 && this.title.setTitle(n);
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(Wr));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  wo = new C('', { providedIn: 'root', factory: () => ({}) }),
  ko = new C(''),
  Ad = (() => {
    let t = class t {
      constructor() {
        (this.componentLoaders = new WeakMap()),
          (this.childrenLoaders = new WeakMap()),
          (this.compiler = h(vn));
      }
      loadComponent(e) {
        if (this.componentLoaders.get(e)) return this.componentLoaders.get(e);
        if (e._loadedComponent) return b(e._loadedComponent);
        this.onLoadStartListener && this.onLoadStartListener(e);
        let n = Ut(e.loadComponent()).pipe(
            x(Da),
            R((a) => {
              this.onLoadEndListener && this.onLoadEndListener(e),
                (e._loadedComponent = a);
            }),
            Ht(() => {
              this.componentLoaders.delete(e);
            })
          ),
          r = new cn(n, () => new lt()).pipe(sn());
        return this.componentLoaders.set(e, r), r;
      }
      loadChildren(e, n) {
        if (this.childrenLoaders.get(n)) return this.childrenLoaders.get(n);
        if (n._loadedRoutes)
          return b({ routes: n._loadedRoutes, injector: n._loadedInjector });
        this.onLoadStartListener && this.onLoadStartListener(n);
        let a = Md(n, this.compiler, e, this.onLoadEndListener).pipe(
            Ht(() => {
              this.childrenLoaders.delete(n);
            })
          ),
          s = new cn(a, () => new lt()).pipe(sn());
        return this.childrenLoaders.set(n, s), s;
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
function Md(i, t, o, e) {
  return Ut(i.loadChildren()).pipe(
    x(Da),
    ht((n) =>
      n instanceof hr || Array.isArray(n) ? b(n) : ut(t.compileModuleAsync(n))
    ),
    x((n) => {
      e && e(i);
      let r,
        a,
        s = !1;
      return (
        Array.isArray(n)
          ? ((a = n), (s = !0))
          : ((r = n.create(o).injector),
            (a = r.get(ko, [], { optional: !0, self: !0 }).flat())),
        { routes: a.map(yo), injector: r }
      );
    })
  );
}
function Td(i) {
  return i && typeof i == 'object' && 'default' in i;
}
function Da(i) {
  return Td(i) ? i.default : i;
}
var Co = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: () => h(Sd), providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Sd = (() => {
    let t = class t {
      shouldProcessUrl(e) {
        return !0;
      }
      extract(e) {
        return e;
      }
      merge(e, n) {
        return e;
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Rd = new C('');
var Fd = (() => {
  let t = class t {
    get hasRequestedNavigation() {
      return this.navigationId !== 0;
    }
    constructor() {
      (this.currentNavigation = null),
        (this.currentTransition = null),
        (this.lastSuccessfulNavigation = null),
        (this.events = new lt()),
        (this.transitionAbortSubject = new lt()),
        (this.configLoader = h(Ad)),
        (this.environmentInjector = h(Ee)),
        (this.urlSerializer = h(bo)),
        (this.rootContexts = h(Bi)),
        (this.location = h(wi)),
        (this.inputBindingEnabled = h(_o, { optional: !0 }) !== null),
        (this.titleStrategy = h(Ea)),
        (this.options = h(wo, { optional: !0 }) || {}),
        (this.paramsInheritanceStrategy =
          this.options.paramsInheritanceStrategy || 'emptyOnly'),
        (this.urlHandlingStrategy = h(Co)),
        (this.createViewTransition = h(Rd, { optional: !0 })),
        (this.navigationId = 0),
        (this.afterPreactivation = () => b(void 0)),
        (this.rootComponentType = null);
      let e = (r) => this.events.next(new Xn(r)),
        n = (r) => this.events.next(new Jn(r));
      (this.configLoader.onLoadEndListener = n),
        (this.configLoader.onLoadStartListener = e);
    }
    complete() {
      this.transitions?.complete();
    }
    handleNavigationRequest(e) {
      let n = ++this.navigationId;
      this.transitions?.next(U(u(u({}, this.transitions.value), e), { id: n }));
    }
    setupNavigations(e, n, r) {
      return (
        (this.transitions = new X({
          id: 0,
          currentUrlTree: n,
          currentRawUrl: n,
          extractedUrl: this.urlHandlingStrategy.extract(n),
          urlAfterRedirects: this.urlHandlingStrategy.extract(n),
          rawUrl: n,
          extras: {},
          resolve: null,
          reject: null,
          promise: Promise.resolve(!0),
          source: Ge,
          restoredState: null,
          currentSnapshot: r.snapshot,
          targetSnapshot: null,
          currentRouterState: r,
          targetRouterState: null,
          guards: { canActivateChecks: [], canDeactivateChecks: [] },
          guardsResult: null,
        })),
        this.transitions.pipe(
          It((a) => a.id !== 0),
          x((a) =>
            U(u({}, a), {
              extractedUrl: this.urlHandlingStrategy.extract(a.rawUrl),
            })
          ),
          _t((a) => {
            let s = !1,
              c = !1;
            return b(a).pipe(
              _t((d) => {
                if (this.navigationId > a.id)
                  return (
                    this.cancelNavigationTransition(
                      a,
                      '',
                      ct.SupersededByNewNavigation
                    ),
                    Tt
                  );
                (this.currentTransition = a),
                  (this.currentNavigation = {
                    id: d.id,
                    initialUrl: d.rawUrl,
                    extractedUrl: d.extractedUrl,
                    trigger: d.source,
                    extras: d.extras,
                    previousNavigation: this.lastSuccessfulNavigation
                      ? U(u({}, this.lastSuccessfulNavigation), {
                          previousNavigation: null,
                        })
                      : null,
                  });
                let l =
                    !e.navigated ||
                    this.isUpdatingInternalState() ||
                    this.isUpdatedBrowserUrl(),
                  m = d.extras.onSameUrlNavigation ?? e.onSameUrlNavigation;
                if (!l && m !== 'reload') {
                  let p = '';
                  return (
                    this.events.next(
                      new Jt(
                        d.id,
                        this.urlSerializer.serialize(d.rawUrl),
                        p,
                        Wn.IgnoredSameUrlNavigation
                      )
                    ),
                    d.resolve(null),
                    Tt
                  );
                }
                if (this.urlHandlingStrategy.shouldProcessUrl(d.rawUrl))
                  return b(d).pipe(
                    _t((p) => {
                      let I = this.transitions?.getValue();
                      return (
                        this.events.next(
                          new Ke(
                            p.id,
                            this.urlSerializer.serialize(p.extractedUrl),
                            p.source,
                            p.restoredState
                          )
                        ),
                        I !== this.transitions?.getValue()
                          ? Tt
                          : Promise.resolve(p)
                      );
                    }),
                    wd(
                      this.environmentInjector,
                      this.configLoader,
                      this.rootComponentType,
                      e.config,
                      this.urlSerializer,
                      this.paramsInheritanceStrategy
                    ),
                    R((p) => {
                      (a.targetSnapshot = p.targetSnapshot),
                        (a.urlAfterRedirects = p.urlAfterRedirects),
                        (this.currentNavigation = U(
                          u({}, this.currentNavigation),
                          { finalUrl: p.urlAfterRedirects }
                        ));
                      let I = new Pi(
                        p.id,
                        this.urlSerializer.serialize(p.extractedUrl),
                        this.urlSerializer.serialize(p.urlAfterRedirects),
                        p.targetSnapshot
                      );
                      this.events.next(I);
                    })
                  );
                if (
                  l &&
                  this.urlHandlingStrategy.shouldProcessUrl(d.currentRawUrl)
                ) {
                  let {
                      id: p,
                      extractedUrl: I,
                      source: gt,
                      restoredState: Z,
                      extras: At,
                    } = d,
                    dt = new Ke(p, this.urlSerializer.serialize(I), gt, Z);
                  this.events.next(dt);
                  let Mt = fa(this.rootComponentType).snapshot;
                  return (
                    (this.currentTransition = a =
                      U(u({}, d), {
                        targetSnapshot: Mt,
                        urlAfterRedirects: I,
                        extras: U(u({}, At), {
                          skipLocationChange: !1,
                          replaceUrl: !1,
                        }),
                      })),
                    (this.currentNavigation.finalUrl = I),
                    b(a)
                  );
                } else {
                  let p = '';
                  return (
                    this.events.next(
                      new Jt(
                        d.id,
                        this.urlSerializer.serialize(d.extractedUrl),
                        p,
                        Wn.IgnoredByUrlHandlingStrategy
                      )
                    ),
                    d.resolve(null),
                    Tt
                  );
                }
              }),
              R((d) => {
                let l = new Kn(
                  d.id,
                  this.urlSerializer.serialize(d.extractedUrl),
                  this.urlSerializer.serialize(d.urlAfterRedirects),
                  d.targetSnapshot
                );
                this.events.next(l);
              }),
              x(
                (d) => (
                  (this.currentTransition = a =
                    U(u({}, d), {
                      guards: Uc(
                        d.targetSnapshot,
                        d.currentSnapshot,
                        this.rootContexts
                      ),
                    })),
                  a
                )
              ),
              Qc(this.environmentInjector, (d) => this.events.next(d)),
              R((d) => {
                if (((a.guardsResult = d.guardsResult), pe(d.guardsResult)))
                  throw _a(this.urlSerializer, d.guardsResult);
                let l = new Zn(
                  d.id,
                  this.urlSerializer.serialize(d.extractedUrl),
                  this.urlSerializer.serialize(d.urlAfterRedirects),
                  d.targetSnapshot,
                  !!d.guardsResult
                );
                this.events.next(l);
              }),
              It((d) =>
                d.guardsResult
                  ? !0
                  : (this.cancelNavigationTransition(d, '', ct.GuardRejected),
                    !1)
              ),
              zn((d) => {
                if (d.guards.canActivateChecks.length)
                  return b(d).pipe(
                    R((l) => {
                      let m = new Qn(
                        l.id,
                        this.urlSerializer.serialize(l.extractedUrl),
                        this.urlSerializer.serialize(l.urlAfterRedirects),
                        l.targetSnapshot
                      );
                      this.events.next(m);
                    }),
                    _t((l) => {
                      let m = !1;
                      return b(l).pipe(
                        kd(
                          this.paramsInheritanceStrategy,
                          this.environmentInjector
                        ),
                        R({
                          next: () => (m = !0),
                          complete: () => {
                            m ||
                              this.cancelNavigationTransition(
                                l,
                                '',
                                ct.NoDataFromResolver
                              );
                          },
                        })
                      );
                    }),
                    R((l) => {
                      let m = new Yn(
                        l.id,
                        this.urlSerializer.serialize(l.extractedUrl),
                        this.urlSerializer.serialize(l.urlAfterRedirects),
                        l.targetSnapshot
                      );
                      this.events.next(m);
                    })
                  );
              }),
              zn((d) => {
                let l = (m) => {
                  let p = [];
                  m.routeConfig?.loadComponent &&
                    !m.routeConfig._loadedComponent &&
                    p.push(
                      this.configLoader.loadComponent(m.routeConfig).pipe(
                        R((I) => {
                          m.component = I;
                        }),
                        x(() => {})
                      )
                    );
                  for (let I of m.children) p.push(...l(I));
                  return p;
                };
                return Ce(l(d.targetSnapshot.root)).pipe(un(null), vt(1));
              }),
              zn(() => this.afterPreactivation()),
              _t(() => {
                let { currentSnapshot: d, targetSnapshot: l } = a,
                  m = this.createViewTransition?.(
                    this.environmentInjector,
                    d.root,
                    l.root
                  );
                return m ? ut(m).pipe(x(() => a)) : b(a);
              }),
              x((d) => {
                let l = Rc(
                  e.routeReuseStrategy,
                  d.targetSnapshot,
                  d.currentRouterState
                );
                return (
                  (this.currentTransition = a =
                    U(u({}, d), { targetRouterState: l })),
                  (this.currentNavigation.targetRouterState = l),
                  a
                );
              }),
              R(() => {
                this.events.next(new Qe());
              }),
              Lc(
                this.rootContexts,
                e.routeReuseStrategy,
                (d) => this.events.next(d),
                this.inputBindingEnabled
              ),
              vt(1),
              R({
                next: (d) => {
                  (s = !0),
                    (this.lastSuccessfulNavigation = this.currentNavigation),
                    this.events.next(
                      new Xt(
                        d.id,
                        this.urlSerializer.serialize(d.extractedUrl),
                        this.urlSerializer.serialize(d.urlAfterRedirects)
                      )
                    ),
                    this.titleStrategy?.updateTitle(
                      d.targetRouterState.snapshot
                    ),
                    d.resolve(!0);
                },
                complete: () => {
                  s = !0;
                },
              }),
              ne(
                this.transitionAbortSubject.pipe(
                  R((d) => {
                    throw d;
                  })
                )
              ),
              Ht(() => {
                !s &&
                  !c &&
                  this.cancelNavigationTransition(
                    a,
                    '',
                    ct.SupersededByNewNavigation
                  ),
                  this.currentTransition?.id === a.id &&
                    ((this.currentNavigation = null),
                    (this.currentTransition = null));
              }),
              St((d) => {
                if (((c = !0), xa(d)))
                  this.events.next(
                    new Lt(
                      a.id,
                      this.urlSerializer.serialize(a.extractedUrl),
                      d.message,
                      d.cancellationCode
                    )
                  ),
                    Nc(d) ? this.events.next(new Ye(d.url)) : a.resolve(!1);
                else {
                  this.events.next(
                    new Ze(
                      a.id,
                      this.urlSerializer.serialize(a.extractedUrl),
                      d,
                      a.targetSnapshot ?? void 0
                    )
                  );
                  try {
                    a.resolve(e.errorHandler(d));
                  } catch (l) {
                    this.options.resolveNavigationPromiseOnError
                      ? a.resolve(!1)
                      : a.reject(l);
                  }
                }
                return Tt;
              })
            );
          })
        )
      );
    }
    cancelNavigationTransition(e, n, r) {
      let a = new Lt(e.id, this.urlSerializer.serialize(e.extractedUrl), n, r);
      this.events.next(a), e.resolve(!1);
    }
    isUpdatingInternalState() {
      return (
        this.currentTransition?.extractedUrl.toString() !==
        this.currentTransition?.currentUrlTree.toString()
      );
    }
    isUpdatedBrowserUrl() {
      return (
        this.urlHandlingStrategy
          .extract(this.urlSerializer.parse(this.location.path(!0)))
          .toString() !== this.currentTransition?.extractedUrl.toString() &&
        !this.currentTransition?.extras.skipLocationChange
      );
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
  let i = t;
  return i;
})();
function Od(i) {
  return i !== Ge;
}
var Nd = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: () => h(Pd), providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  fo = class {
    shouldDetach(t) {
      return !1;
    }
    store(t, o) {}
    shouldAttach(t) {
      return !1;
    }
    retrieve(t) {
      return null;
    }
    shouldReuseRoute(t, o) {
      return t.routeConfig === o.routeConfig;
    }
  },
  Pd = (() => {
    let t = class t extends fo {};
    (t.ɵfac = (() => {
      let e;
      return function (r) {
        return (e || (e = Ae(t)))(r || t);
      };
    })()),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Aa = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: () => h(Vd), providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Vd = (() => {
    let t = class t extends Aa {
      constructor() {
        super(...arguments),
          (this.location = h(wi)),
          (this.urlSerializer = h(bo)),
          (this.options = h(wo, { optional: !0 }) || {}),
          (this.canceledNavigationResolution =
            this.options.canceledNavigationResolution || 'replace'),
          (this.urlHandlingStrategy = h(Co)),
          (this.urlUpdateStrategy =
            this.options.urlUpdateStrategy || 'deferred'),
          (this.currentUrlTree = new jt()),
          (this.rawUrlTree = this.currentUrlTree),
          (this.currentPageId = 0),
          (this.lastSuccessfulId = -1),
          (this.routerState = fa(null)),
          (this.stateMemento = this.createStateMemento());
      }
      getCurrentUrlTree() {
        return this.currentUrlTree;
      }
      getRawUrlTree() {
        return this.rawUrlTree;
      }
      restoredState() {
        return this.location.getState();
      }
      get browserPageId() {
        return this.canceledNavigationResolution !== 'computed'
          ? this.currentPageId
          : this.restoredState()?.ɵrouterPageId ?? this.currentPageId;
      }
      getRouterState() {
        return this.routerState;
      }
      createStateMemento() {
        return {
          rawUrlTree: this.rawUrlTree,
          currentUrlTree: this.currentUrlTree,
          routerState: this.routerState,
        };
      }
      registerNonRouterCurrentEntryChangeListener(e) {
        return this.location.subscribe((n) => {
          n.type === 'popstate' && e(n.url, n.state);
        });
      }
      handleRouterEvent(e, n) {
        if (e instanceof Ke) this.stateMemento = this.createStateMemento();
        else if (e instanceof Jt) this.rawUrlTree = n.initialUrl;
        else if (e instanceof Pi) {
          if (
            this.urlUpdateStrategy === 'eager' &&
            !n.extras.skipLocationChange
          ) {
            let r = this.urlHandlingStrategy.merge(n.finalUrl, n.initialUrl);
            this.setBrowserUrl(r, n);
          }
        } else
          e instanceof Qe
            ? ((this.currentUrlTree = n.finalUrl),
              (this.rawUrlTree = this.urlHandlingStrategy.merge(
                n.finalUrl,
                n.initialUrl
              )),
              (this.routerState = n.targetRouterState),
              this.urlUpdateStrategy === 'deferred' &&
                (n.extras.skipLocationChange ||
                  this.setBrowserUrl(this.rawUrlTree, n)))
            : e instanceof Lt &&
                (e.code === ct.GuardRejected ||
                  e.code === ct.NoDataFromResolver)
              ? this.restoreHistory(n)
              : e instanceof Ze
                ? this.restoreHistory(n, !0)
                : e instanceof Xt &&
                  ((this.lastSuccessfulId = e.id),
                  (this.currentPageId = this.browserPageId));
      }
      setBrowserUrl(e, n) {
        let r = this.urlSerializer.serialize(e);
        if (this.location.isCurrentPathEqualTo(r) || n.extras.replaceUrl) {
          let a = this.browserPageId,
            s = u(u({}, n.extras.state), this.generateNgRouterState(n.id, a));
          this.location.replaceState(r, '', s);
        } else {
          let a = u(
            u({}, n.extras.state),
            this.generateNgRouterState(n.id, this.browserPageId + 1)
          );
          this.location.go(r, '', a);
        }
      }
      restoreHistory(e, n = !1) {
        if (this.canceledNavigationResolution === 'computed') {
          let r = this.browserPageId,
            a = this.currentPageId - r;
          a !== 0
            ? this.location.historyGo(a)
            : this.currentUrlTree === e.finalUrl &&
              a === 0 &&
              (this.resetState(e), this.resetUrlToCurrentUrlTree());
        } else
          this.canceledNavigationResolution === 'replace' &&
            (n && this.resetState(e), this.resetUrlToCurrentUrlTree());
      }
      resetState(e) {
        (this.routerState = this.stateMemento.routerState),
          (this.currentUrlTree = this.stateMemento.currentUrlTree),
          (this.rawUrlTree = this.urlHandlingStrategy.merge(
            this.currentUrlTree,
            e.finalUrl ?? this.rawUrlTree
          ));
      }
      resetUrlToCurrentUrlTree() {
        this.location.replaceState(
          this.urlSerializer.serialize(this.rawUrlTree),
          '',
          this.generateNgRouterState(this.lastSuccessfulId, this.currentPageId)
        );
      }
      generateNgRouterState(e, n) {
        return this.canceledNavigationResolution === 'computed'
          ? { navigationId: e, ɵrouterPageId: n }
          : { navigationId: e };
      }
    };
    (t.ɵfac = (() => {
      let e;
      return function (r) {
        return (e || (e = Ae(t)))(r || t);
      };
    })()),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  $e = (function (i) {
    return (
      (i[(i.COMPLETE = 0)] = 'COMPLETE'),
      (i[(i.FAILED = 1)] = 'FAILED'),
      (i[(i.REDIRECTING = 2)] = 'REDIRECTING'),
      i
    );
  })($e || {});
function jd(i, t) {
  i.events
    .pipe(
      It(
        (o) =>
          o instanceof Xt ||
          o instanceof Lt ||
          o instanceof Ze ||
          o instanceof Jt
      ),
      x((o) =>
        o instanceof Xt || o instanceof Jt
          ? $e.COMPLETE
          : (
                o instanceof Lt
                  ? o.code === ct.Redirect ||
                    o.code === ct.SupersededByNewNavigation
                  : !1
              )
            ? $e.REDIRECTING
            : $e.FAILED
      ),
      It((o) => o !== $e.REDIRECTING),
      vt(1)
    )
    .subscribe(() => {
      t();
    });
}
function Ld(i) {
  throw i;
}
var Ud = {
    paths: 'exact',
    fragment: 'ignored',
    matrixParams: 'ignored',
    queryParams: 'exact',
  },
  zd = {
    paths: 'subset',
    fragment: 'ignored',
    matrixParams: 'ignored',
    queryParams: 'subset',
  },
  Ma = (() => {
    let t = class t {
      get currentUrlTree() {
        return this.stateManager.getCurrentUrlTree();
      }
      get rawUrlTree() {
        return this.stateManager.getRawUrlTree();
      }
      get events() {
        return this._events;
      }
      get routerState() {
        return this.stateManager.getRouterState();
      }
      constructor() {
        (this.disposed = !1),
          (this.isNgZoneEnabled = !1),
          (this.console = h(yi)),
          (this.stateManager = h(Aa)),
          (this.options = h(wo, { optional: !0 }) || {}),
          (this.pendingTasks = h(pn)),
          (this.urlUpdateStrategy =
            this.options.urlUpdateStrategy || 'deferred'),
          (this.navigationTransitions = h(Fd)),
          (this.urlSerializer = h(bo)),
          (this.location = h(wi)),
          (this.urlHandlingStrategy = h(Co)),
          (this._events = new lt()),
          (this.errorHandler = this.options.errorHandler || Ld),
          (this.navigated = !1),
          (this.routeReuseStrategy = h(Nd)),
          (this.onSameUrlNavigation =
            this.options.onSameUrlNavigation || 'ignore'),
          (this.config = h(ko, { optional: !0 })?.flat() ?? []),
          (this.componentInputBindingEnabled = !!h(_o, { optional: !0 })),
          (this.eventsSubscription = new ke()),
          (this.isNgZoneEnabled = h(A) instanceof A && A.isInAngularZone()),
          this.resetConfig(this.config),
          this.navigationTransitions
            .setupNavigations(this, this.currentUrlTree, this.routerState)
            .subscribe({
              error: (e) => {
                this.console.warn(e);
              },
            }),
          this.subscribeToNavigationEvents();
      }
      subscribeToNavigationEvents() {
        let e = this.navigationTransitions.events.subscribe((n) => {
          try {
            let r = this.navigationTransitions.currentTransition,
              a = this.navigationTransitions.currentNavigation;
            if (r !== null && a !== null) {
              if (
                (this.stateManager.handleRouterEvent(n, a),
                n instanceof Lt &&
                  n.code !== ct.Redirect &&
                  n.code !== ct.SupersededByNewNavigation)
              )
                this.navigated = !0;
              else if (n instanceof Xt) this.navigated = !0;
              else if (n instanceof Ye) {
                let s = this.urlHandlingStrategy.merge(n.url, r.currentRawUrl),
                  c = {
                    info: r.extras.info,
                    skipLocationChange: r.extras.skipLocationChange,
                    replaceUrl:
                      this.urlUpdateStrategy === 'eager' || Od(r.source),
                  };
                this.scheduleNavigation(s, Ge, null, c, {
                  resolve: r.resolve,
                  reject: r.reject,
                  promise: r.promise,
                });
              }
            }
            $d(n) && this._events.next(n);
          } catch (r) {
            this.navigationTransitions.transitionAbortSubject.next(r);
          }
        });
        this.eventsSubscription.add(e);
      }
      resetRootComponentType(e) {
        (this.routerState.root.component = e),
          (this.navigationTransitions.rootComponentType = e);
      }
      initialNavigation() {
        this.setUpLocationChangeListener(),
          this.navigationTransitions.hasRequestedNavigation ||
            this.navigateToSyncWithBrowser(
              this.location.path(!0),
              Ge,
              this.stateManager.restoredState()
            );
      }
      setUpLocationChangeListener() {
        this.nonRouterCurrentEntryChangeSubscription ??=
          this.stateManager.registerNonRouterCurrentEntryChangeListener(
            (e, n) => {
              setTimeout(() => {
                this.navigateToSyncWithBrowser(e, 'popstate', n);
              }, 0);
            }
          );
      }
      navigateToSyncWithBrowser(e, n, r) {
        let a = { replaceUrl: !0 },
          s = r?.navigationId ? r : null;
        if (r) {
          let d = u({}, r);
          delete d.navigationId,
            delete d.ɵrouterPageId,
            Object.keys(d).length !== 0 && (a.state = d);
        }
        let c = this.parseUrl(e);
        this.scheduleNavigation(c, n, s, a);
      }
      get url() {
        return this.serializeUrl(this.currentUrlTree);
      }
      getCurrentNavigation() {
        return this.navigationTransitions.currentNavigation;
      }
      get lastSuccessfulNavigation() {
        return this.navigationTransitions.lastSuccessfulNavigation;
      }
      resetConfig(e) {
        (this.config = e.map(yo)), (this.navigated = !1);
      }
      ngOnDestroy() {
        this.dispose();
      }
      dispose() {
        this.navigationTransitions.complete(),
          this.nonRouterCurrentEntryChangeSubscription &&
            (this.nonRouterCurrentEntryChangeSubscription.unsubscribe(),
            (this.nonRouterCurrentEntryChangeSubscription = void 0)),
          (this.disposed = !0),
          this.eventsSubscription.unsubscribe();
      }
      createUrlTree(e, n = {}) {
        let {
            relativeTo: r,
            queryParams: a,
            fragment: s,
            queryParamsHandling: c,
            preserveFragment: d,
          } = n,
          l = d ? this.currentUrlTree.fragment : s,
          m = null;
        switch (c) {
          case 'merge':
            m = u(u({}, this.currentUrlTree.queryParams), a);
            break;
          case 'preserve':
            m = this.currentUrlTree.queryParams;
            break;
          default:
            m = a || null;
        }
        m !== null && (m = this.removeEmptyProps(m));
        let p;
        try {
          let I = r ? r.snapshot : this.routerState.snapshot.root;
          p = ua(I);
        } catch {
          (typeof e[0] != 'string' || !e[0].startsWith('/')) && (e = []),
            (p = this.currentUrlTree.root);
        }
        return ha(p, e, m, l ?? null);
      }
      navigateByUrl(e, n = { skipLocationChange: !1 }) {
        let r = pe(e) ? e : this.parseUrl(e),
          a = this.urlHandlingStrategy.merge(r, this.rawUrlTree);
        return this.scheduleNavigation(a, Ge, null, n);
      }
      navigate(e, n = { skipLocationChange: !1 }) {
        return Bd(e), this.navigateByUrl(this.createUrlTree(e, n), n);
      }
      serializeUrl(e) {
        return this.urlSerializer.serialize(e);
      }
      parseUrl(e) {
        try {
          return this.urlSerializer.parse(e);
        } catch {
          return this.urlSerializer.parse('/');
        }
      }
      isActive(e, n) {
        let r;
        if (
          (n === !0 ? (r = u({}, Ud)) : n === !1 ? (r = u({}, zd)) : (r = n),
          pe(e))
        )
          return Qr(this.currentUrlTree, e, r);
        let a = this.parseUrl(e);
        return Qr(this.currentUrlTree, a, r);
      }
      removeEmptyProps(e) {
        return Object.entries(e).reduce(
          (n, [r, a]) => (a != null && (n[r] = a), n),
          {}
        );
      }
      scheduleNavigation(e, n, r, a, s) {
        if (this.disposed) return Promise.resolve(!1);
        let c, d, l;
        s
          ? ((c = s.resolve), (d = s.reject), (l = s.promise))
          : (l = new Promise((p, I) => {
              (c = p), (d = I);
            }));
        let m = this.pendingTasks.add();
        return (
          jd(this, () => {
            queueMicrotask(() => this.pendingTasks.remove(m));
          }),
          this.navigationTransitions.handleNavigationRequest({
            source: n,
            restoredState: r,
            currentUrlTree: this.currentUrlTree,
            currentRawUrl: this.currentUrlTree,
            rawUrl: e,
            extras: a,
            resolve: c,
            reject: d,
            promise: l,
            currentSnapshot: this.routerState.snapshot,
            currentRouterState: this.routerState,
          }),
          l.catch((p) => Promise.reject(p))
        );
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
function Bd(i) {
  for (let t = 0; t < i.length; t++) if (i[t] == null) throw new M(4008, !1);
}
function $d(i) {
  return !(i instanceof Qe) && !(i instanceof Ye);
}
var Hd = new C('');
function Ta(i, ...t) {
  return Gt([
    { provide: ko, multi: !0, useValue: i },
    [],
    { provide: fe, useFactory: Gd, deps: [Ma] },
    { provide: xi, multi: !0, useFactory: qd },
    t.map((o) => o.ɵproviders),
  ]);
}
function Gd(i) {
  return i.routerState.root;
}
function qd() {
  let i = h(tr);
  return (t) => {
    let o = i.get(Oe);
    if (t !== o.components[0]) return;
    let e = i.get(Ma),
      n = i.get(Wd);
    i.get(Kd) === 1 && e.initialNavigation(),
      i.get(Zd, null, mn.Optional)?.setUpPreloading(),
      i.get(Hd, null, mn.Optional)?.init(),
      e.resetRootComponentType(o.componentTypes[0]),
      n.closed || (n.next(), n.complete(), n.unsubscribe());
  };
}
var Wd = new C('', { factory: () => new lt() }),
  Kd = new C('', { providedIn: 'root', factory: () => 1 });
var Zd = new C('');
var Sa = [];
var Qd = '@',
  Yd = (() => {
    let t = class t {
      constructor(e, n, r, a, s) {
        (this.doc = e),
          (this.delegate = n),
          (this.zone = r),
          (this.animationType = a),
          (this.moduleImpl = s),
          (this._rendererFactoryPromise = null),
          (this.scheduler = h(lr, { optional: !0 }));
      }
      ngOnDestroy() {
        this._engine?.flush();
      }
      loadImpl() {
        return (this.moduleImpl ?? import('./chunk-ZQYPUSHE.js'))
          .catch((n) => {
            throw new M(5300, !1);
          })
          .then(({ ɵcreateEngine: n, ɵAnimationRendererFactory: r }) => {
            this._engine = n(this.animationType, this.doc, this.scheduler);
            let a = new r(this.delegate, this._engine, this.zone);
            return (this.delegate = a), a;
          });
      }
      createRenderer(e, n) {
        let r = this.delegate.createRenderer(e, n);
        if (r.ɵtype === 0) return r;
        typeof r.throwOnSyntheticProps == 'boolean' &&
          (r.throwOnSyntheticProps = !1);
        let a = new Io(r);
        return (
          n?.data?.animation &&
            !this._rendererFactoryPromise &&
            (this._rendererFactoryPromise = this.loadImpl()),
          this._rendererFactoryPromise
            ?.then((s) => {
              let c = s.createRenderer(e, n);
              a.use(c);
            })
            .catch((s) => {
              a.use(r);
            }),
          a
        );
      }
      begin() {
        this.delegate.begin?.();
      }
      end() {
        this.delegate.end?.();
      }
      whenRenderingDone() {
        return this.delegate.whenRenderingDone?.() ?? Promise.resolve();
      }
    };
    (t.ɵfac = function (n) {
      Se();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac }));
    let i = t;
    return i;
  })(),
  Io = class {
    constructor(t) {
      (this.delegate = t), (this.replay = []), (this.ɵtype = 1);
    }
    use(t) {
      if (((this.delegate = t), this.replay !== null)) {
        for (let o of this.replay) o(t);
        this.replay = null;
      }
    }
    get data() {
      return this.delegate.data;
    }
    destroy() {
      (this.replay = null), this.delegate.destroy();
    }
    createElement(t, o) {
      return this.delegate.createElement(t, o);
    }
    createComment(t) {
      return this.delegate.createComment(t);
    }
    createText(t) {
      return this.delegate.createText(t);
    }
    get destroyNode() {
      return this.delegate.destroyNode;
    }
    appendChild(t, o) {
      this.delegate.appendChild(t, o);
    }
    insertBefore(t, o, e, n) {
      this.delegate.insertBefore(t, o, e, n);
    }
    removeChild(t, o, e) {
      this.delegate.removeChild(t, o, e);
    }
    selectRootElement(t, o) {
      return this.delegate.selectRootElement(t, o);
    }
    parentNode(t) {
      return this.delegate.parentNode(t);
    }
    nextSibling(t) {
      return this.delegate.nextSibling(t);
    }
    setAttribute(t, o, e, n) {
      this.delegate.setAttribute(t, o, e, n);
    }
    removeAttribute(t, o, e) {
      this.delegate.removeAttribute(t, o, e);
    }
    addClass(t, o) {
      this.delegate.addClass(t, o);
    }
    removeClass(t, o) {
      this.delegate.removeClass(t, o);
    }
    setStyle(t, o, e, n) {
      this.delegate.setStyle(t, o, e, n);
    }
    removeStyle(t, o, e) {
      this.delegate.removeStyle(t, o, e);
    }
    setProperty(t, o, e) {
      this.shouldReplay(o) && this.replay.push((n) => n.setProperty(t, o, e)),
        this.delegate.setProperty(t, o, e);
    }
    setValue(t, o) {
      this.delegate.setValue(t, o);
    }
    listen(t, o, e) {
      return (
        this.shouldReplay(o) && this.replay.push((n) => n.listen(t, o, e)),
        this.delegate.listen(t, o, e)
      );
    }
    shouldReplay(t) {
      return this.replay !== null && t.startsWith(Qd);
    }
  };
function Ra(i = 'animations') {
  return (
    pi('NgAsyncAnimations'),
    Gt([
      {
        provide: mi,
        useFactory: (t, o, e) => new Yd(t, o, e, i),
        deps: [S, Ei, A],
      },
      {
        provide: it,
        useValue: i === 'noop' ? 'NoopAnimations' : 'BrowserAnimations',
      },
    ])
  );
}
var Fa = { providers: [Ta(Sa), Kr(), Ra()] };
var Do;
try {
  Do = typeof Intl < 'u' && Intl.v8BreakIterator;
} catch {
  Do = !1;
}
var et = (() => {
  let t = class t {
    constructor(e) {
      (this._platformId = e),
        (this.isBrowser = this._platformId
          ? wr(this._platformId)
          : typeof document == 'object' && !!document),
        (this.EDGE = this.isBrowser && /(edge)/i.test(navigator.userAgent)),
        (this.TRIDENT =
          this.isBrowser && /(msie|trident)/i.test(navigator.userAgent)),
        (this.BLINK =
          this.isBrowser &&
          !!(window.chrome || Do) &&
          typeof CSS < 'u' &&
          !this.EDGE &&
          !this.TRIDENT),
        (this.WEBKIT =
          this.isBrowser &&
          /AppleWebKit/i.test(navigator.userAgent) &&
          !this.BLINK &&
          !this.EDGE &&
          !this.TRIDENT),
        (this.IOS =
          this.isBrowser &&
          /iPad|iPhone|iPod/.test(navigator.userAgent) &&
          !('MSStream' in window)),
        (this.FIREFOX =
          this.isBrowser && /(firefox|minefield)/i.test(navigator.userAgent)),
        (this.ANDROID =
          this.isBrowser &&
          /android/i.test(navigator.userAgent) &&
          !this.TRIDENT),
        (this.SAFARI =
          this.isBrowser && /safari/i.test(navigator.userAgent) && this.WEBKIT);
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)(f(Et));
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
  let i = t;
  return i;
})();
var oi;
function Xd() {
  if (oi == null && typeof window < 'u')
    try {
      window.addEventListener(
        'test',
        null,
        Object.defineProperty({}, 'passive', { get: () => (oi = !0) })
      );
    } finally {
      oi = oi || !1;
    }
  return oi;
}
function ve(i) {
  return Xd() ? i : !!i.capture;
}
var Eo;
function Jd() {
  if (Eo == null) {
    let i = typeof document < 'u' ? document.head : null;
    Eo = !!(i && (i.createShadowRoot || i.attachShadow));
  }
  return Eo;
}
function Oa(i) {
  if (Jd()) {
    let t = i.getRootNode ? i.getRootNode() : null;
    if (typeof ShadowRoot < 'u' && ShadowRoot && t instanceof ShadowRoot)
      return t;
  }
  return null;
}
function zt(i) {
  return i.composedPath ? i.composedPath()[0] : i.target;
}
function Na() {
  return (
    (typeof __karma__ < 'u' && !!__karma__) ||
    (typeof jasmine < 'u' && !!jasmine) ||
    (typeof jest < 'u' && !!jest) ||
    (typeof Mocha < 'u' && !!Mocha)
  );
}
function Ao(i) {
  return Array.isArray(i) ? i : [i];
}
function te(i) {
  return i instanceof V ? i.nativeElement : i;
}
var Pa = new Set(),
  ee,
  tl = (() => {
    let t = class t {
      constructor(e, n) {
        (this._platform = e),
          (this._nonce = n),
          (this._matchMedia =
            this._platform.isBrowser && window.matchMedia
              ? window.matchMedia.bind(window)
              : il);
      }
      matchMedia(e) {
        return (
          (this._platform.WEBKIT || this._platform.BLINK) && el(e, this._nonce),
          this._matchMedia(e)
        );
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(et), f(Me, 8));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
function el(i, t) {
  if (!Pa.has(i))
    try {
      ee ||
        ((ee = document.createElement('style')),
        t && ee.setAttribute('nonce', t),
        ee.setAttribute('type', 'text/css'),
        document.head.appendChild(ee)),
        ee.sheet &&
          (ee.sheet.insertRule(`@media ${i} {body{ }}`, 0), Pa.add(i));
    } catch (o) {
      console.error(o);
    }
}
function il(i) {
  return {
    matches: i === 'all' || i === '',
    media: i,
    addListener: () => {},
    removeListener: () => {},
  };
}
var ja = (() => {
  let t = class t {
    constructor(e, n) {
      (this._mediaMatcher = e),
        (this._zone = n),
        (this._queries = new Map()),
        (this._destroySubject = new lt());
    }
    ngOnDestroy() {
      this._destroySubject.next(), this._destroySubject.complete();
    }
    isMatched(e) {
      return Va(Ao(e)).some((r) => this._registerQuery(r).mql.matches);
    }
    observe(e) {
      let r = Va(Ao(e)).map((s) => this._registerQuery(s).observable),
        a = Ce(r);
      return (
        (a = si(a.pipe(vt(1)), a.pipe(ci(1), ln(0)))),
        a.pipe(
          x((s) => {
            let c = { matches: !1, breakpoints: {} };
            return (
              s.forEach(({ matches: d, query: l }) => {
                (c.matches = c.matches || d), (c.breakpoints[l] = d);
              }),
              c
            );
          })
        )
      );
    }
    _registerQuery(e) {
      if (this._queries.has(e)) return this._queries.get(e);
      let n = this._mediaMatcher.matchMedia(e),
        a = {
          observable: new an((s) => {
            let c = (d) => this._zone.run(() => s.next(d));
            return (
              n.addListener(c),
              () => {
                n.removeListener(c);
              }
            );
          }).pipe(
            di(n),
            x(({ matches: s }) => ({ query: e, matches: s })),
            ne(this._destroySubject)
          ),
          mql: n,
        };
      return this._queries.set(e, a), a;
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)(f(tl), f(A));
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
  let i = t;
  return i;
})();
function Va(i) {
  return i
    .map((t) => t.split(','))
    .reduce((t, o) => t.concat(o))
    .map((t) => t.trim());
}
function To(i) {
  return i.buttons === 0 || i.detail === 0;
}
function So(i) {
  let t =
    (i.touches && i.touches[0]) || (i.changedTouches && i.changedTouches[0]);
  return (
    !!t &&
    t.identifier === -1 &&
    (t.radiusX == null || t.radiusX === 1) &&
    (t.radiusY == null || t.radiusY === 1)
  );
}
var ol = new C('cdk-input-modality-detector-options'),
  rl = { ignoreKeys: [18, 17, 224, 91, 16] },
  za = 650,
  _e = ve({ passive: !0, capture: !0 }),
  al = (() => {
    let t = class t {
      get mostRecentModality() {
        return this._modality.value;
      }
      constructor(e, n, r, a) {
        (this._platform = e),
          (this._mostRecentTarget = null),
          (this._modality = new X(null)),
          (this._lastTouchMs = 0),
          (this._onKeydown = (s) => {
            this._options?.ignoreKeys?.some((c) => c === s.keyCode) ||
              (this._modality.next('keyboard'),
              (this._mostRecentTarget = zt(s)));
          }),
          (this._onMousedown = (s) => {
            Date.now() - this._lastTouchMs < za ||
              (this._modality.next(To(s) ? 'keyboard' : 'mouse'),
              (this._mostRecentTarget = zt(s)));
          }),
          (this._onTouchstart = (s) => {
            if (So(s)) {
              this._modality.next('keyboard');
              return;
            }
            (this._lastTouchMs = Date.now()),
              this._modality.next('touch'),
              (this._mostRecentTarget = zt(s));
          }),
          (this._options = u(u({}, rl), a)),
          (this.modalityDetected = this._modality.pipe(ci(1))),
          (this.modalityChanged = this.modalityDetected.pipe(Ko())),
          e.isBrowser &&
            n.runOutsideAngular(() => {
              r.addEventListener('keydown', this._onKeydown, _e),
                r.addEventListener('mousedown', this._onMousedown, _e),
                r.addEventListener('touchstart', this._onTouchstart, _e);
            });
      }
      ngOnDestroy() {
        this._modality.complete(),
          this._platform.isBrowser &&
            (document.removeEventListener('keydown', this._onKeydown, _e),
            document.removeEventListener('mousedown', this._onMousedown, _e),
            document.removeEventListener('touchstart', this._onTouchstart, _e));
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(et), f(A), f(S), f(ol, 8));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
var qi = (function (i) {
    return (
      (i[(i.IMMEDIATE = 0)] = 'IMMEDIATE'),
      (i[(i.EVENTUAL = 1)] = 'EVENTUAL'),
      i
    );
  })(qi || {}),
  sl = new C('cdk-focus-monitor-default-options'),
  Gi = ve({ passive: !0, capture: !0 }),
  Wi = (() => {
    let t = class t {
      constructor(e, n, r, a, s) {
        (this._ngZone = e),
          (this._platform = n),
          (this._inputModalityDetector = r),
          (this._origin = null),
          (this._windowFocused = !1),
          (this._originFromTouchInteraction = !1),
          (this._elementInfo = new Map()),
          (this._monitoredElementCount = 0),
          (this._rootNodeFocusListenerCount = new Map()),
          (this._windowFocusListener = () => {
            (this._windowFocused = !0),
              (this._windowFocusTimeoutId = window.setTimeout(
                () => (this._windowFocused = !1)
              ));
          }),
          (this._stopInputModalityDetector = new lt()),
          (this._rootNodeFocusAndBlurListener = (c) => {
            let d = zt(c);
            for (let l = d; l; l = l.parentElement)
              c.type === 'focus' ? this._onFocus(c, l) : this._onBlur(c, l);
          }),
          (this._document = a),
          (this._detectionMode = s?.detectionMode || qi.IMMEDIATE);
      }
      monitor(e, n = !1) {
        let r = te(e);
        if (!this._platform.isBrowser || r.nodeType !== 1) return b();
        let a = Oa(r) || this._getDocument(),
          s = this._elementInfo.get(r);
        if (s) return n && (s.checkChildren = !0), s.subject;
        let c = { checkChildren: n, subject: new lt(), rootNode: a };
        return (
          this._elementInfo.set(r, c),
          this._registerGlobalListeners(c),
          c.subject
        );
      }
      stopMonitoring(e) {
        let n = te(e),
          r = this._elementInfo.get(n);
        r &&
          (r.subject.complete(),
          this._setClasses(n),
          this._elementInfo.delete(n),
          this._removeGlobalListeners(r));
      }
      focusVia(e, n, r) {
        let a = te(e),
          s = this._getDocument().activeElement;
        a === s
          ? this._getClosestElementsInfo(a).forEach(([c, d]) =>
              this._originChanged(c, n, d)
            )
          : (this._setOrigin(n), typeof a.focus == 'function' && a.focus(r));
      }
      ngOnDestroy() {
        this._elementInfo.forEach((e, n) => this.stopMonitoring(n));
      }
      _getDocument() {
        return this._document || document;
      }
      _getWindow() {
        return this._getDocument().defaultView || window;
      }
      _getFocusOrigin(e) {
        return this._origin
          ? this._originFromTouchInteraction
            ? this._shouldBeAttributedToTouch(e)
              ? 'touch'
              : 'program'
            : this._origin
          : this._windowFocused && this._lastFocusOrigin
            ? this._lastFocusOrigin
            : e && this._isLastInteractionFromInputLabel(e)
              ? 'mouse'
              : 'program';
      }
      _shouldBeAttributedToTouch(e) {
        return (
          this._detectionMode === qi.EVENTUAL ||
          !!e?.contains(this._inputModalityDetector._mostRecentTarget)
        );
      }
      _setClasses(e, n) {
        e.classList.toggle('cdk-focused', !!n),
          e.classList.toggle('cdk-touch-focused', n === 'touch'),
          e.classList.toggle('cdk-keyboard-focused', n === 'keyboard'),
          e.classList.toggle('cdk-mouse-focused', n === 'mouse'),
          e.classList.toggle('cdk-program-focused', n === 'program');
      }
      _setOrigin(e, n = !1) {
        this._ngZone.runOutsideAngular(() => {
          if (
            ((this._origin = e),
            (this._originFromTouchInteraction = e === 'touch' && n),
            this._detectionMode === qi.IMMEDIATE)
          ) {
            clearTimeout(this._originTimeoutId);
            let r = this._originFromTouchInteraction ? za : 1;
            this._originTimeoutId = setTimeout(() => (this._origin = null), r);
          }
        });
      }
      _onFocus(e, n) {
        let r = this._elementInfo.get(n),
          a = zt(e);
        !r ||
          (!r.checkChildren && n !== a) ||
          this._originChanged(n, this._getFocusOrigin(a), r);
      }
      _onBlur(e, n) {
        let r = this._elementInfo.get(n);
        !r ||
          (r.checkChildren &&
            e.relatedTarget instanceof Node &&
            n.contains(e.relatedTarget)) ||
          (this._setClasses(n), this._emitOrigin(r, null));
      }
      _emitOrigin(e, n) {
        e.subject.observers.length && this._ngZone.run(() => e.subject.next(n));
      }
      _registerGlobalListeners(e) {
        if (!this._platform.isBrowser) return;
        let n = e.rootNode,
          r = this._rootNodeFocusListenerCount.get(n) || 0;
        r ||
          this._ngZone.runOutsideAngular(() => {
            n.addEventListener('focus', this._rootNodeFocusAndBlurListener, Gi),
              n.addEventListener(
                'blur',
                this._rootNodeFocusAndBlurListener,
                Gi
              );
          }),
          this._rootNodeFocusListenerCount.set(n, r + 1),
          ++this._monitoredElementCount === 1 &&
            (this._ngZone.runOutsideAngular(() => {
              this._getWindow().addEventListener(
                'focus',
                this._windowFocusListener
              );
            }),
            this._inputModalityDetector.modalityDetected
              .pipe(ne(this._stopInputModalityDetector))
              .subscribe((a) => {
                this._setOrigin(a, !0);
              }));
      }
      _removeGlobalListeners(e) {
        let n = e.rootNode;
        if (this._rootNodeFocusListenerCount.has(n)) {
          let r = this._rootNodeFocusListenerCount.get(n);
          r > 1
            ? this._rootNodeFocusListenerCount.set(n, r - 1)
            : (n.removeEventListener(
                'focus',
                this._rootNodeFocusAndBlurListener,
                Gi
              ),
              n.removeEventListener(
                'blur',
                this._rootNodeFocusAndBlurListener,
                Gi
              ),
              this._rootNodeFocusListenerCount.delete(n));
        }
        --this._monitoredElementCount ||
          (this._getWindow().removeEventListener(
            'focus',
            this._windowFocusListener
          ),
          this._stopInputModalityDetector.next(),
          clearTimeout(this._windowFocusTimeoutId),
          clearTimeout(this._originTimeoutId));
      }
      _originChanged(e, n, r) {
        this._setClasses(e, n),
          this._emitOrigin(r, n),
          (this._lastFocusOrigin = n);
      }
      _getClosestElementsInfo(e) {
        let n = [];
        return (
          this._elementInfo.forEach((r, a) => {
            (a === e || (r.checkChildren && a.contains(e))) && n.push([a, r]);
          }),
          n
        );
      }
      _isLastInteractionFromInputLabel(e) {
        let { _mostRecentTarget: n, mostRecentModality: r } =
          this._inputModalityDetector;
        if (
          r !== 'mouse' ||
          !n ||
          n === e ||
          (e.nodeName !== 'INPUT' && e.nodeName !== 'TEXTAREA') ||
          e.disabled
        )
          return !1;
        let a = e.labels;
        if (a) {
          for (let s = 0; s < a.length; s++) if (a[s].contains(n)) return !0;
        }
        return !1;
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(A), f(et), f(al), f(S, 8), f(sl, 8));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
var ie = (function (i) {
    return (
      (i[(i.NONE = 0)] = 'NONE'),
      (i[(i.BLACK_ON_WHITE = 1)] = 'BLACK_ON_WHITE'),
      (i[(i.WHITE_ON_BLACK = 2)] = 'WHITE_ON_BLACK'),
      i
    );
  })(ie || {}),
  La = 'cdk-high-contrast-black-on-white',
  Ua = 'cdk-high-contrast-white-on-black',
  Mo = 'cdk-high-contrast-active',
  Ba = (() => {
    let t = class t {
      constructor(e, n) {
        (this._platform = e),
          (this._document = n),
          (this._breakpointSubscription = h(ja)
            .observe('(forced-colors: active)')
            .subscribe(() => {
              this._hasCheckedHighContrastMode &&
                ((this._hasCheckedHighContrastMode = !1),
                this._applyBodyHighContrastModeCssClasses());
            }));
      }
      getHighContrastMode() {
        if (!this._platform.isBrowser) return ie.NONE;
        let e = this._document.createElement('div');
        (e.style.backgroundColor = 'rgb(1,2,3)'),
          (e.style.position = 'absolute'),
          this._document.body.appendChild(e);
        let n = this._document.defaultView || window,
          r = n && n.getComputedStyle ? n.getComputedStyle(e) : null,
          a = ((r && r.backgroundColor) || '').replace(/ /g, '');
        switch ((e.remove(), a)) {
          case 'rgb(0,0,0)':
          case 'rgb(45,50,54)':
          case 'rgb(32,32,32)':
            return ie.WHITE_ON_BLACK;
          case 'rgb(255,255,255)':
          case 'rgb(255,250,239)':
            return ie.BLACK_ON_WHITE;
        }
        return ie.NONE;
      }
      ngOnDestroy() {
        this._breakpointSubscription.unsubscribe();
      }
      _applyBodyHighContrastModeCssClasses() {
        if (
          !this._hasCheckedHighContrastMode &&
          this._platform.isBrowser &&
          this._document.body
        ) {
          let e = this._document.body.classList;
          e.remove(Mo, La, Ua), (this._hasCheckedHighContrastMode = !0);
          let n = this.getHighContrastMode();
          n === ie.BLACK_ON_WHITE
            ? e.add(Mo, La)
            : n === ie.WHITE_ON_BLACK && e.add(Mo, Ua);
        }
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(et), f(S));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
var Ro = (() => {
  let t = class t {};
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵmod = N({ type: t })),
    (t.ɵinj = O({}));
  let i = t;
  return i;
})();
var cl = ['mat-internal-form-field', ''],
  dl = ['*'];
function ll() {
  return !0;
}
var ul = new C('mat-sanity-checks', { providedIn: 'root', factory: ll }),
  $ = (() => {
    let t = class t {
      constructor(e, n, r) {
        (this._sanityChecks = n),
          (this._document = r),
          (this._hasDoneGlobalChecks = !1),
          e._applyBodyHighContrastModeCssClasses(),
          this._hasDoneGlobalChecks || (this._hasDoneGlobalChecks = !0);
      }
      _checkIsEnabled(e) {
        return Na()
          ? !1
          : typeof this._sanityChecks == 'boolean'
            ? this._sanityChecks
            : !!this._sanityChecks[e];
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(Ba), f(ul, 8), f(S));
    }),
      (t.ɵmod = N({ type: t })),
      (t.ɵinj = O({ imports: [Ro, Ro] }));
    let i = t;
    return i;
  })();
var Xa = (() => {
  let t = class t {
    isErrorState(e, n) {
      return !!(e && e.invalid && (e.touched || (n && n.submitted)));
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
  let i = t;
  return i;
})();
var bt = (function (i) {
    return (
      (i[(i.FADING_IN = 0)] = 'FADING_IN'),
      (i[(i.VISIBLE = 1)] = 'VISIBLE'),
      (i[(i.FADING_OUT = 2)] = 'FADING_OUT'),
      (i[(i.HIDDEN = 3)] = 'HIDDEN'),
      i
    );
  })(bt || {}),
  No = class {
    constructor(t, o, e, n = !1) {
      (this._renderer = t),
        (this.element = o),
        (this.config = e),
        (this._animationForciblyDisabledThroughCss = n),
        (this.state = bt.HIDDEN);
    }
    fadeOut() {
      this._renderer.fadeOutRipple(this);
    }
  },
  Ha = ve({ passive: !0, capture: !0 }),
  Po = class {
    constructor() {
      (this._events = new Map()),
        (this._delegateEventHandler = (t) => {
          let o = zt(t);
          o &&
            this._events.get(t.type)?.forEach((e, n) => {
              (n === o || n.contains(o)) && e.forEach((r) => r.handleEvent(t));
            });
        });
    }
    addHandler(t, o, e, n) {
      let r = this._events.get(o);
      if (r) {
        let a = r.get(e);
        a ? a.add(n) : r.set(e, new Set([n]));
      } else
        this._events.set(o, new Map([[e, new Set([n])]])),
          t.runOutsideAngular(() => {
            document.addEventListener(o, this._delegateEventHandler, Ha);
          });
    }
    removeHandler(t, o, e) {
      let n = this._events.get(t);
      if (!n) return;
      let r = n.get(o);
      r &&
        (r.delete(e),
        r.size === 0 && n.delete(o),
        n.size === 0 &&
          (this._events.delete(t),
          document.removeEventListener(t, this._delegateEventHandler, Ha)));
    }
  },
  Ga = { enterDuration: 225, exitDuration: 150 },
  hl = 800,
  qa = ve({ passive: !0, capture: !0 }),
  Wa = ['mousedown', 'touchstart'],
  Ka = ['mouseup', 'mouseleave', 'touchend', 'touchcancel'],
  ri = class ri {
    constructor(t, o, e, n) {
      (this._target = t),
        (this._ngZone = o),
        (this._platform = n),
        (this._isPointerDown = !1),
        (this._activeRipples = new Map()),
        (this._pointerUpEventsRegistered = !1),
        n.isBrowser && (this._containerElement = te(e));
    }
    fadeInRipple(t, o, e = {}) {
      let n = (this._containerRect =
          this._containerRect ||
          this._containerElement.getBoundingClientRect()),
        r = u(u({}, Ga), e.animation);
      e.centered && ((t = n.left + n.width / 2), (o = n.top + n.height / 2));
      let a = e.radius || ml(t, o, n),
        s = t - n.left,
        c = o - n.top,
        d = r.enterDuration,
        l = document.createElement('div');
      l.classList.add('mat-ripple-element'),
        (l.style.left = `${s - a}px`),
        (l.style.top = `${c - a}px`),
        (l.style.height = `${a * 2}px`),
        (l.style.width = `${a * 2}px`),
        e.color != null && (l.style.backgroundColor = e.color),
        (l.style.transitionDuration = `${d}ms`),
        this._containerElement.appendChild(l);
      let m = window.getComputedStyle(l),
        p = m.transitionProperty,
        I = m.transitionDuration,
        gt =
          p === 'none' ||
          I === '0s' ||
          I === '0s, 0s' ||
          (n.width === 0 && n.height === 0),
        Z = new No(this, l, e, gt);
      (l.style.transform = 'scale3d(1, 1, 1)'),
        (Z.state = bt.FADING_IN),
        e.persistent || (this._mostRecentTransientRipple = Z);
      let At = null;
      return (
        !gt &&
          (d || r.exitDuration) &&
          this._ngZone.runOutsideAngular(() => {
            let dt = () => this._finishRippleTransition(Z),
              Mt = () => this._destroyRipple(Z);
            l.addEventListener('transitionend', dt),
              l.addEventListener('transitioncancel', Mt),
              (At = { onTransitionEnd: dt, onTransitionCancel: Mt });
          }),
        this._activeRipples.set(Z, At),
        (gt || !d) && this._finishRippleTransition(Z),
        Z
      );
    }
    fadeOutRipple(t) {
      if (t.state === bt.FADING_OUT || t.state === bt.HIDDEN) return;
      let o = t.element,
        e = u(u({}, Ga), t.config.animation);
      (o.style.transitionDuration = `${e.exitDuration}ms`),
        (o.style.opacity = '0'),
        (t.state = bt.FADING_OUT),
        (t._animationForciblyDisabledThroughCss || !e.exitDuration) &&
          this._finishRippleTransition(t);
    }
    fadeOutAll() {
      this._getActiveRipples().forEach((t) => t.fadeOut());
    }
    fadeOutAllNonPersistent() {
      this._getActiveRipples().forEach((t) => {
        t.config.persistent || t.fadeOut();
      });
    }
    setupTriggerEvents(t) {
      let o = te(t);
      !this._platform.isBrowser ||
        !o ||
        o === this._triggerElement ||
        (this._removeTriggerEvents(),
        (this._triggerElement = o),
        Wa.forEach((e) => {
          ri._eventManager.addHandler(this._ngZone, e, o, this);
        }));
    }
    handleEvent(t) {
      t.type === 'mousedown'
        ? this._onMousedown(t)
        : t.type === 'touchstart'
          ? this._onTouchStart(t)
          : this._onPointerUp(),
        this._pointerUpEventsRegistered ||
          (this._ngZone.runOutsideAngular(() => {
            Ka.forEach((o) => {
              this._triggerElement.addEventListener(o, this, qa);
            });
          }),
          (this._pointerUpEventsRegistered = !0));
    }
    _finishRippleTransition(t) {
      t.state === bt.FADING_IN
        ? this._startFadeOutTransition(t)
        : t.state === bt.FADING_OUT && this._destroyRipple(t);
    }
    _startFadeOutTransition(t) {
      let o = t === this._mostRecentTransientRipple,
        { persistent: e } = t.config;
      (t.state = bt.VISIBLE), !e && (!o || !this._isPointerDown) && t.fadeOut();
    }
    _destroyRipple(t) {
      let o = this._activeRipples.get(t) ?? null;
      this._activeRipples.delete(t),
        this._activeRipples.size || (this._containerRect = null),
        t === this._mostRecentTransientRipple &&
          (this._mostRecentTransientRipple = null),
        (t.state = bt.HIDDEN),
        o !== null &&
          (t.element.removeEventListener('transitionend', o.onTransitionEnd),
          t.element.removeEventListener(
            'transitioncancel',
            o.onTransitionCancel
          )),
        t.element.remove();
    }
    _onMousedown(t) {
      let o = To(t),
        e =
          this._lastTouchStartEvent &&
          Date.now() < this._lastTouchStartEvent + hl;
      !this._target.rippleDisabled &&
        !o &&
        !e &&
        ((this._isPointerDown = !0),
        this.fadeInRipple(t.clientX, t.clientY, this._target.rippleConfig));
    }
    _onTouchStart(t) {
      if (!this._target.rippleDisabled && !So(t)) {
        (this._lastTouchStartEvent = Date.now()), (this._isPointerDown = !0);
        let o = t.changedTouches;
        if (o)
          for (let e = 0; e < o.length; e++)
            this.fadeInRipple(
              o[e].clientX,
              o[e].clientY,
              this._target.rippleConfig
            );
      }
    }
    _onPointerUp() {
      this._isPointerDown &&
        ((this._isPointerDown = !1),
        this._getActiveRipples().forEach((t) => {
          let o =
            t.state === bt.VISIBLE ||
            (t.config.terminateOnPointerUp && t.state === bt.FADING_IN);
          !t.config.persistent && o && t.fadeOut();
        }));
    }
    _getActiveRipples() {
      return Array.from(this._activeRipples.keys());
    }
    _removeTriggerEvents() {
      let t = this._triggerElement;
      t &&
        (Wa.forEach((o) => ri._eventManager.removeHandler(o, t, this)),
        this._pointerUpEventsRegistered &&
          Ka.forEach((o) => t.removeEventListener(o, this, qa)));
    }
  };
ri._eventManager = new Po();
var Vo = ri;
function ml(i, t, o) {
  let e = Math.max(Math.abs(i - o.left), Math.abs(i - o.right)),
    n = Math.max(Math.abs(t - o.top), Math.abs(t - o.bottom));
  return Math.sqrt(e * e + n * n);
}
var jo = new C('mat-ripple-global-options'),
  ye = (() => {
    let t = class t {
      get disabled() {
        return this._disabled;
      }
      set disabled(e) {
        e && this.fadeOutAllNonPersistent(),
          (this._disabled = e),
          this._setupTriggerEventsIfEnabled();
      }
      get trigger() {
        return this._trigger || this._elementRef.nativeElement;
      }
      set trigger(e) {
        (this._trigger = e), this._setupTriggerEventsIfEnabled();
      }
      constructor(e, n, r, a, s) {
        (this._elementRef = e),
          (this._animationMode = s),
          (this.radius = 0),
          (this._disabled = !1),
          (this._isInitialized = !1),
          (this._globalOptions = a || {}),
          (this._rippleRenderer = new Vo(this, n, e, r));
      }
      ngOnInit() {
        (this._isInitialized = !0), this._setupTriggerEventsIfEnabled();
      }
      ngOnDestroy() {
        this._rippleRenderer._removeTriggerEvents();
      }
      fadeOutAll() {
        this._rippleRenderer.fadeOutAll();
      }
      fadeOutAllNonPersistent() {
        this._rippleRenderer.fadeOutAllNonPersistent();
      }
      get rippleConfig() {
        return {
          centered: this.centered,
          radius: this.radius,
          color: this.color,
          animation: u(
            u(
              u({}, this._globalOptions.animation),
              this._animationMode === 'NoopAnimations'
                ? { enterDuration: 0, exitDuration: 0 }
                : {}
            ),
            this.animation
          ),
          terminateOnPointerUp: this._globalOptions.terminateOnPointerUp,
        };
      }
      get rippleDisabled() {
        return this.disabled || !!this._globalOptions.disabled;
      }
      _setupTriggerEventsIfEnabled() {
        !this.disabled &&
          this._isInitialized &&
          this._rippleRenderer.setupTriggerEvents(this.trigger);
      }
      launch(e, n = 0, r) {
        return typeof e == 'number'
          ? this._rippleRenderer.fadeInRipple(
              e,
              n,
              u(u({}, this.rippleConfig), r)
            )
          : this._rippleRenderer.fadeInRipple(
              0,
              0,
              u(u({}, this.rippleConfig), e)
            );
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(k(V), k(A), k(et), k(jo, 8), k(it, 8));
    }),
      (t.ɵdir = mt({
        type: t,
        selectors: [
          ['', 'mat-ripple', ''],
          ['', 'matRipple', ''],
        ],
        hostAttrs: [1, 'mat-ripple'],
        hostVars: 2,
        hostBindings: function (n, r) {
          n & 2 && q('mat-ripple-unbounded', r.unbounded);
        },
        inputs: {
          color: [w.None, 'matRippleColor', 'color'],
          unbounded: [w.None, 'matRippleUnbounded', 'unbounded'],
          centered: [w.None, 'matRippleCentered', 'centered'],
          radius: [w.None, 'matRippleRadius', 'radius'],
          animation: [w.None, 'matRippleAnimation', 'animation'],
          disabled: [w.None, 'matRippleDisabled', 'disabled'],
          trigger: [w.None, 'matRippleTrigger', 'trigger'],
        },
        exportAs: ['matRipple'],
        standalone: !0,
      }));
    let i = t;
    return i;
  })(),
  xe = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵmod = N({ type: t })),
      (t.ɵinj = O({ imports: [$, $] }));
    let i = t;
    return i;
  })();
var Za = { capture: !0 },
  Qa = ['focus', 'click', 'mouseenter', 'touchstart'],
  Fo = 'mat-ripple-loader-uninitialized',
  Oo = 'mat-ripple-loader-class-name',
  Ya = 'mat-ripple-loader-centered',
  Ki = 'mat-ripple-loader-disabled',
  Lo = (() => {
    let t = class t {
      constructor() {
        (this._document = h(S, { optional: !0 })),
          (this._animationMode = h(it, { optional: !0 })),
          (this._globalRippleOptions = h(jo, { optional: !0 })),
          (this._platform = h(et)),
          (this._ngZone = h(A)),
          (this._hosts = new Map()),
          (this._onInteraction = (e) => {
            if (!(e.target instanceof HTMLElement)) return;
            let r = e.target.closest(`[${Fo}]`);
            r && this._createRipple(r);
          }),
          this._ngZone.runOutsideAngular(() => {
            for (let e of Qa)
              this._document?.addEventListener(e, this._onInteraction, Za);
          });
      }
      ngOnDestroy() {
        let e = this._hosts.keys();
        for (let n of e) this.destroyRipple(n);
        for (let n of Qa)
          this._document?.removeEventListener(n, this._onInteraction, Za);
      }
      configureRipple(e, n) {
        e.setAttribute(Fo, ''),
          (n.className || !e.hasAttribute(Oo)) &&
            e.setAttribute(Oo, n.className || ''),
          n.centered && e.setAttribute(Ya, ''),
          n.disabled && e.setAttribute(Ki, '');
      }
      getRipple(e) {
        return this._hosts.get(e) || this._createRipple(e);
      }
      setDisabled(e, n) {
        let r = this._hosts.get(e);
        if (r) {
          r.disabled = n;
          return;
        }
        n ? e.setAttribute(Ki, '') : e.removeAttribute(Ki);
      }
      _createRipple(e) {
        if (!this._document) return;
        let n = this._hosts.get(e);
        if (n) return n;
        e.querySelector('.mat-ripple')?.remove();
        let r = this._document.createElement('span');
        r.classList.add('mat-ripple', e.getAttribute(Oo)), e.append(r);
        let a = new ye(
          new V(r),
          this._ngZone,
          this._platform,
          this._globalRippleOptions ? this._globalRippleOptions : void 0,
          this._animationMode ? this._animationMode : void 0
        );
        return (
          (a._isInitialized = !0),
          (a.trigger = e),
          (a.centered = e.hasAttribute(Ya)),
          (a.disabled = e.hasAttribute(Ki)),
          this.attachRipple(e, a),
          a
        );
      }
      attachRipple(e, n) {
        e.removeAttribute(Fo), this._hosts.set(e, n);
      }
      destroyRipple(e) {
        let n = this._hosts.get(e);
        n && (n.ngOnDestroy(), this._hosts.delete(e));
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })(),
  Zi = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵcmp = P({
        type: t,
        selectors: [['div', 'mat-internal-form-field', '']],
        hostAttrs: [1, 'mdc-form-field', 'mat-internal-form-field'],
        hostVars: 2,
        hostBindings: function (n, r) {
          n & 2 && q('mdc-form-field--align-end', r.labelPosition === 'before');
        },
        inputs: { labelPosition: 'labelPosition' },
        standalone: !0,
        features: [j],
        attrs: cl,
        ngContentSelectors: dl,
        decls: 1,
        vars: 0,
        template: function (n, r) {
          n & 1 && (pt(), tt(0));
        },
        styles: [
          '.mdc-form-field{display:inline-flex;align-items:center;vertical-align:middle}.mdc-form-field[hidden]{display:none}.mdc-form-field>label{margin-left:0;margin-right:auto;padding-left:4px;padding-right:0;order:0}[dir=rtl] .mdc-form-field>label,.mdc-form-field>label[dir=rtl]{margin-left:auto;margin-right:0}[dir=rtl] .mdc-form-field>label,.mdc-form-field>label[dir=rtl]{padding-left:0;padding-right:4px}.mdc-form-field--nowrap>label{text-overflow:ellipsis;overflow:hidden;white-space:nowrap}.mdc-form-field--align-end>label{margin-left:auto;margin-right:0;padding-left:0;padding-right:4px;order:-1}[dir=rtl] .mdc-form-field--align-end>label,.mdc-form-field--align-end>label[dir=rtl]{margin-left:0;margin-right:auto}[dir=rtl] .mdc-form-field--align-end>label,.mdc-form-field--align-end>label[dir=rtl]{padding-left:4px;padding-right:0}.mdc-form-field--space-between{justify-content:space-between}.mdc-form-field--space-between>label{margin:0}[dir=rtl] .mdc-form-field--space-between>label,.mdc-form-field--space-between>label[dir=rtl]{margin:0}.mdc-form-field{font-family:var(--mdc-form-field-label-text-font);line-height:var(--mdc-form-field-label-text-line-height);font-size:var(--mdc-form-field-label-text-size);font-weight:var(--mdc-form-field-label-text-weight);letter-spacing:var(--mdc-form-field-label-text-tracking);color:var(--mdc-form-field-label-text-color)}.mat-internal-form-field{-moz-osx-font-smoothing:grayscale;-webkit-font-smoothing:antialiased}',
        ],
        encapsulation: 2,
        changeDetection: 0,
      }));
    let i = t;
    return i;
  })();
var pl = ['mat-button', ''],
  fl = [
    [
      ['', 8, 'material-icons', 3, 'iconPositionEnd', ''],
      ['mat-icon', 3, 'iconPositionEnd', ''],
      ['', 'matButtonIcon', '', 3, 'iconPositionEnd', ''],
    ],
    '*',
    [
      ['', 'iconPositionEnd', '', 8, 'material-icons'],
      ['mat-icon', 'iconPositionEnd', ''],
      ['', 'matButtonIcon', '', 'iconPositionEnd', ''],
    ],
  ],
  bl = [
    '.material-icons:not([iconPositionEnd]), mat-icon:not([iconPositionEnd]), [matButtonIcon]:not([iconPositionEnd])',
    '*',
    '.material-icons[iconPositionEnd], mat-icon[iconPositionEnd], [matButtonIcon][iconPositionEnd]',
  ];
var gl =
  '.cdk-high-contrast-active .mat-mdc-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-unelevated-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-raised-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-outlined-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-icon-button{outline:solid 1px}';
var vl = ['mat-icon-button', ''],
  _l = ['*'];
var yl = new C('MAT_BUTTON_CONFIG');
var xl = [
    { attribute: 'mat-button', mdcClasses: ['mdc-button', 'mat-mdc-button'] },
    {
      attribute: 'mat-flat-button',
      mdcClasses: [
        'mdc-button',
        'mdc-button--unelevated',
        'mat-mdc-unelevated-button',
      ],
    },
    {
      attribute: 'mat-raised-button',
      mdcClasses: ['mdc-button', 'mdc-button--raised', 'mat-mdc-raised-button'],
    },
    {
      attribute: 'mat-stroked-button',
      mdcClasses: [
        'mdc-button',
        'mdc-button--outlined',
        'mat-mdc-outlined-button',
      ],
    },
    { attribute: 'mat-fab', mdcClasses: ['mdc-fab', 'mat-mdc-fab'] },
    {
      attribute: 'mat-mini-fab',
      mdcClasses: ['mdc-fab', 'mdc-fab--mini', 'mat-mdc-mini-fab'],
    },
    {
      attribute: 'mat-icon-button',
      mdcClasses: ['mdc-icon-button', 'mat-mdc-icon-button'],
    },
  ],
  Ja = (() => {
    let t = class t {
      get ripple() {
        return this._rippleLoader?.getRipple(this._elementRef.nativeElement);
      }
      set ripple(e) {
        this._rippleLoader?.attachRipple(this._elementRef.nativeElement, e);
      }
      get disableRipple() {
        return this._disableRipple;
      }
      set disableRipple(e) {
        (this._disableRipple = e), this._updateRippleDisabled();
      }
      get disabled() {
        return this._disabled;
      }
      set disabled(e) {
        (this._disabled = e), this._updateRippleDisabled();
      }
      constructor(e, n, r, a) {
        (this._elementRef = e),
          (this._platform = n),
          (this._ngZone = r),
          (this._animationMode = a),
          (this._focusMonitor = h(Wi)),
          (this._rippleLoader = h(Lo)),
          (this._isFab = !1),
          (this._disableRipple = !1),
          (this._disabled = !1);
        let s = h(yl, { optional: !0 }),
          c = e.nativeElement,
          d = c.classList;
        (this.disabledInteractive = s?.disabledInteractive ?? !1),
          this._rippleLoader?.configureRipple(c, {
            className: 'mat-mdc-button-ripple',
          });
        for (let { attribute: l, mdcClasses: m } of xl)
          c.hasAttribute(l) && d.add(...m);
      }
      ngAfterViewInit() {
        this._focusMonitor.monitor(this._elementRef, !0);
      }
      ngOnDestroy() {
        this._focusMonitor.stopMonitoring(this._elementRef),
          this._rippleLoader?.destroyRipple(this._elementRef.nativeElement);
      }
      focus(e = 'program', n) {
        e
          ? this._focusMonitor.focusVia(this._elementRef.nativeElement, e, n)
          : this._elementRef.nativeElement.focus(n);
      }
      _getAriaDisabled() {
        return this.ariaDisabled != null
          ? this.ariaDisabled
          : this.disabled && this.disabledInteractive
            ? !0
            : null;
      }
      _getDisabledAttribute() {
        return this.disabledInteractive || !this.disabled ? null : !0;
      }
      _updateRippleDisabled() {
        this._rippleLoader?.setDisabled(
          this._elementRef.nativeElement,
          this.disableRipple || this.disabled
        );
      }
    };
    (t.ɵfac = function (n) {
      Se();
    }),
      (t.ɵdir = mt({
        type: t,
        inputs: {
          color: 'color',
          disableRipple: [
            w.HasDecoratorInputTransform,
            'disableRipple',
            'disableRipple',
            T,
          ],
          disabled: [w.HasDecoratorInputTransform, 'disabled', 'disabled', T],
          ariaDisabled: [
            w.HasDecoratorInputTransform,
            'aria-disabled',
            'ariaDisabled',
            T,
          ],
          disabledInteractive: [
            w.HasDecoratorInputTransform,
            'disabledInteractive',
            'disabledInteractive',
            T,
          ],
        },
        features: [ot],
      }));
    let i = t;
    return i;
  })();
var Qi = (() => {
  let t = class t extends Ja {
    constructor(e, n, r, a) {
      super(e, n, r, a);
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)(k(V), k(et), k(A), k(it, 8));
  }),
    (t.ɵcmp = P({
      type: t,
      selectors: [
        ['button', 'mat-button', ''],
        ['button', 'mat-raised-button', ''],
        ['button', 'mat-flat-button', ''],
        ['button', 'mat-stroked-button', ''],
      ],
      hostVars: 14,
      hostBindings: function (n, r) {
        n & 2 &&
          (Y('disabled', r._getDisabledAttribute())(
            'aria-disabled',
            r._getAriaDisabled()
          ),
          wt(r.color ? 'mat-' + r.color : ''),
          q('mat-mdc-button-disabled', r.disabled)(
            'mat-mdc-button-disabled-interactive',
            r.disabledInteractive
          )('_mat-animation-noopable', r._animationMode === 'NoopAnimations')(
            'mat-unthemed',
            !r.color
          )('mat-mdc-button-base', !0));
      },
      exportAs: ['matButton'],
      standalone: !0,
      features: [Fe, j],
      attrs: pl,
      ngContentSelectors: bl,
      decls: 7,
      vars: 4,
      consts: [
        [1, 'mat-mdc-button-persistent-ripple'],
        [1, 'mdc-button__label'],
        [1, 'mat-mdc-focus-indicator'],
        [1, 'mat-mdc-button-touch-target'],
      ],
      template: function (n, r) {
        n & 1 &&
          (pt(fl),
          F(0, 'span', 0),
          tt(1),
          v(2, 'span', 1),
          tt(3, 1),
          g(),
          tt(4, 2),
          F(5, 'span', 2)(6, 'span', 3)),
          n & 2 &&
            q('mdc-button__ripple', !r._isFab)('mdc-fab__ripple', r._isFab);
      },
      styles: [
        '.mdc-touch-target-wrapper{display:inline}.mdc-elevation-overlay{position:absolute;border-radius:inherit;pointer-events:none;opacity:var(--mdc-elevation-overlay-opacity, 0);transition:opacity 280ms cubic-bezier(0.4, 0, 0.2, 1)}.mdc-button{position:relative;display:inline-flex;align-items:center;justify-content:center;box-sizing:border-box;min-width:64px;border:none;outline:none;line-height:inherit;user-select:none;-webkit-appearance:none;overflow:visible;vertical-align:middle;background:rgba(0,0,0,0)}.mdc-button .mdc-elevation-overlay{width:100%;height:100%;top:0;left:0}.mdc-button::-moz-focus-inner{padding:0;border:0}.mdc-button:active{outline:none}.mdc-button:hover{cursor:pointer}.mdc-button:disabled{cursor:default;pointer-events:none}.mdc-button[hidden]{display:none}.mdc-button .mdc-button__icon{margin-left:0;margin-right:8px;display:inline-block;position:relative;vertical-align:top}[dir=rtl] .mdc-button .mdc-button__icon,.mdc-button .mdc-button__icon[dir=rtl]{margin-left:8px;margin-right:0}.mdc-button .mdc-button__progress-indicator{font-size:0;position:absolute;transform:translate(-50%, -50%);top:50%;left:50%;line-height:initial}.mdc-button .mdc-button__label{position:relative}.mdc-button .mdc-button__focus-ring{pointer-events:none;border:2px solid rgba(0,0,0,0);border-radius:6px;box-sizing:content-box;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:calc(100% + 4px);width:calc(100% + 4px);display:none}@media screen and (forced-colors: active){.mdc-button .mdc-button__focus-ring{border-color:CanvasText}}.mdc-button .mdc-button__focus-ring::after{content:"";border:2px solid rgba(0,0,0,0);border-radius:8px;display:block;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:calc(100% + 4px);width:calc(100% + 4px)}@media screen and (forced-colors: active){.mdc-button .mdc-button__focus-ring::after{border-color:CanvasText}}@media screen and (forced-colors: active){.mdc-button.mdc-ripple-upgraded--background-focused .mdc-button__focus-ring,.mdc-button:not(.mdc-ripple-upgraded):focus .mdc-button__focus-ring{display:block}}.mdc-button .mdc-button__touch{position:absolute;top:50%;height:48px;left:0;right:0;transform:translateY(-50%)}.mdc-button__label+.mdc-button__icon{margin-left:8px;margin-right:0}[dir=rtl] .mdc-button__label+.mdc-button__icon,.mdc-button__label+.mdc-button__icon[dir=rtl]{margin-left:0;margin-right:8px}svg.mdc-button__icon{fill:currentColor}.mdc-button--touch{margin-top:6px;margin-bottom:6px}.mdc-button{padding:0 8px 0 8px}.mdc-button--unelevated{transition:box-shadow 280ms cubic-bezier(0.4, 0, 0.2, 1);padding:0 16px 0 16px}.mdc-button--unelevated.mdc-button--icon-trailing{padding:0 12px 0 16px}.mdc-button--unelevated.mdc-button--icon-leading{padding:0 16px 0 12px}.mdc-button--raised{transition:box-shadow 280ms cubic-bezier(0.4, 0, 0.2, 1);padding:0 16px 0 16px}.mdc-button--raised.mdc-button--icon-trailing{padding:0 12px 0 16px}.mdc-button--raised.mdc-button--icon-leading{padding:0 16px 0 12px}.mdc-button--outlined{border-style:solid;transition:border 280ms cubic-bezier(0.4, 0, 0.2, 1)}.mdc-button--outlined .mdc-button__ripple{border-style:solid;border-color:rgba(0,0,0,0)}.mat-mdc-button{font-family:var(--mdc-text-button-label-text-font);font-size:var(--mdc-text-button-label-text-size);letter-spacing:var(--mdc-text-button-label-text-tracking);font-weight:var(--mdc-text-button-label-text-weight);text-transform:var(--mdc-text-button-label-text-transform);height:var(--mdc-text-button-container-height);border-radius:var(--mdc-text-button-container-shape);padding:0 var(--mat-text-button-horizontal-padding, 8px)}.mat-mdc-button:not(:disabled){color:var(--mdc-text-button-label-text-color)}.mat-mdc-button:disabled{color:var(--mdc-text-button-disabled-label-text-color)}.mat-mdc-button .mdc-button__ripple{border-radius:var(--mdc-text-button-container-shape)}.mat-mdc-button:has(.material-icons,mat-icon,[matButtonIcon]){padding:0 var(--mat-text-button-with-icon-horizontal-padding, 8px)}.mat-mdc-button>.mat-icon{margin-right:var(--mat-text-button-icon-spacing, 8px);margin-left:var(--mat-text-button-icon-offset, 0)}[dir=rtl] .mat-mdc-button>.mat-icon{margin-right:var(--mat-text-button-icon-offset, 0);margin-left:var(--mat-text-button-icon-spacing, 8px)}.mat-mdc-button .mdc-button__label+.mat-icon{margin-right:var(--mat-text-button-icon-offset, 0);margin-left:var(--mat-text-button-icon-spacing, 8px)}[dir=rtl] .mat-mdc-button .mdc-button__label+.mat-icon{margin-right:var(--mat-text-button-icon-spacing, 8px);margin-left:var(--mat-text-button-icon-offset, 0)}.mat-mdc-button .mat-ripple-element{background-color:var(--mat-text-button-ripple-color)}.mat-mdc-button .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-text-button-state-layer-color)}.mat-mdc-button.mat-mdc-button-disabled .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-text-button-disabled-state-layer-color)}.mat-mdc-button:hover .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-text-button-hover-state-layer-opacity)}.mat-mdc-button.cdk-program-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-button.cdk-keyboard-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-button.mat-mdc-button-disabled-interactive:focus .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-text-button-focus-state-layer-opacity)}.mat-mdc-button:active .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-text-button-pressed-state-layer-opacity)}.mat-mdc-button .mat-mdc-button-touch-target{position:absolute;top:50%;height:48px;left:0;right:0;transform:translateY(-50%);display:var(--mat-text-button-touch-target-display)}.mat-mdc-button[disabled],.mat-mdc-button.mat-mdc-button-disabled{cursor:default;pointer-events:none;color:var(--mdc-text-button-disabled-label-text-color)}.mat-mdc-button.mat-mdc-button-disabled-interactive{pointer-events:auto}.mat-mdc-unelevated-button{font-family:var(--mdc-filled-button-label-text-font);font-size:var(--mdc-filled-button-label-text-size);letter-spacing:var(--mdc-filled-button-label-text-tracking);font-weight:var(--mdc-filled-button-label-text-weight);text-transform:var(--mdc-filled-button-label-text-transform);height:var(--mdc-filled-button-container-height);border-radius:var(--mdc-filled-button-container-shape);padding:0 var(--mat-filled-button-horizontal-padding, 16px)}.mat-mdc-unelevated-button:not(:disabled){background-color:var(--mdc-filled-button-container-color)}.mat-mdc-unelevated-button:disabled{background-color:var(--mdc-filled-button-disabled-container-color)}.mat-mdc-unelevated-button:not(:disabled){color:var(--mdc-filled-button-label-text-color)}.mat-mdc-unelevated-button:disabled{color:var(--mdc-filled-button-disabled-label-text-color)}.mat-mdc-unelevated-button .mdc-button__ripple{border-radius:var(--mdc-filled-button-container-shape)}.mat-mdc-unelevated-button>.mat-icon{margin-right:var(--mat-filled-button-icon-spacing, 8px);margin-left:var(--mat-filled-button-icon-offset, -4px)}[dir=rtl] .mat-mdc-unelevated-button>.mat-icon{margin-right:var(--mat-filled-button-icon-offset, -4px);margin-left:var(--mat-filled-button-icon-spacing, 8px)}.mat-mdc-unelevated-button .mdc-button__label+.mat-icon{margin-right:var(--mat-filled-button-icon-offset, -4px);margin-left:var(--mat-filled-button-icon-spacing, 8px)}[dir=rtl] .mat-mdc-unelevated-button .mdc-button__label+.mat-icon{margin-right:var(--mat-filled-button-icon-spacing, 8px);margin-left:var(--mat-filled-button-icon-offset, -4px)}.mat-mdc-unelevated-button .mat-ripple-element{background-color:var(--mat-filled-button-ripple-color)}.mat-mdc-unelevated-button .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-filled-button-state-layer-color)}.mat-mdc-unelevated-button.mat-mdc-button-disabled .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-filled-button-disabled-state-layer-color)}.mat-mdc-unelevated-button:hover .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-filled-button-hover-state-layer-opacity)}.mat-mdc-unelevated-button.cdk-program-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-unelevated-button.cdk-keyboard-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-unelevated-button.mat-mdc-button-disabled-interactive:focus .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-filled-button-focus-state-layer-opacity)}.mat-mdc-unelevated-button:active .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-filled-button-pressed-state-layer-opacity)}.mat-mdc-unelevated-button .mat-mdc-button-touch-target{position:absolute;top:50%;height:48px;left:0;right:0;transform:translateY(-50%);display:var(--mat-filled-button-touch-target-display)}.mat-mdc-unelevated-button[disabled],.mat-mdc-unelevated-button.mat-mdc-button-disabled{cursor:default;pointer-events:none;color:var(--mdc-filled-button-disabled-label-text-color);background-color:var(--mdc-filled-button-disabled-container-color)}.mat-mdc-unelevated-button.mat-mdc-button-disabled-interactive{pointer-events:auto}.mat-mdc-raised-button{font-family:var(--mdc-protected-button-label-text-font);font-size:var(--mdc-protected-button-label-text-size);letter-spacing:var(--mdc-protected-button-label-text-tracking);font-weight:var(--mdc-protected-button-label-text-weight);text-transform:var(--mdc-protected-button-label-text-transform);height:var(--mdc-protected-button-container-height);border-radius:var(--mdc-protected-button-container-shape);padding:0 var(--mat-protected-button-horizontal-padding, 16px);box-shadow:var(--mdc-protected-button-container-elevation-shadow)}.mat-mdc-raised-button:not(:disabled){background-color:var(--mdc-protected-button-container-color)}.mat-mdc-raised-button:disabled{background-color:var(--mdc-protected-button-disabled-container-color)}.mat-mdc-raised-button:not(:disabled){color:var(--mdc-protected-button-label-text-color)}.mat-mdc-raised-button:disabled{color:var(--mdc-protected-button-disabled-label-text-color)}.mat-mdc-raised-button .mdc-button__ripple{border-radius:var(--mdc-protected-button-container-shape)}.mat-mdc-raised-button>.mat-icon{margin-right:var(--mat-protected-button-icon-spacing, 8px);margin-left:var(--mat-protected-button-icon-offset, -4px)}[dir=rtl] .mat-mdc-raised-button>.mat-icon{margin-right:var(--mat-protected-button-icon-offset, -4px);margin-left:var(--mat-protected-button-icon-spacing, 8px)}.mat-mdc-raised-button .mdc-button__label+.mat-icon{margin-right:var(--mat-protected-button-icon-offset, -4px);margin-left:var(--mat-protected-button-icon-spacing, 8px)}[dir=rtl] .mat-mdc-raised-button .mdc-button__label+.mat-icon{margin-right:var(--mat-protected-button-icon-spacing, 8px);margin-left:var(--mat-protected-button-icon-offset, -4px)}.mat-mdc-raised-button .mat-ripple-element{background-color:var(--mat-protected-button-ripple-color)}.mat-mdc-raised-button .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-protected-button-state-layer-color)}.mat-mdc-raised-button.mat-mdc-button-disabled .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-protected-button-disabled-state-layer-color)}.mat-mdc-raised-button:hover .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-protected-button-hover-state-layer-opacity)}.mat-mdc-raised-button.cdk-program-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-raised-button.cdk-keyboard-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-raised-button.mat-mdc-button-disabled-interactive:focus .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-protected-button-focus-state-layer-opacity)}.mat-mdc-raised-button:active .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-protected-button-pressed-state-layer-opacity)}.mat-mdc-raised-button .mat-mdc-button-touch-target{position:absolute;top:50%;height:48px;left:0;right:0;transform:translateY(-50%);display:var(--mat-protected-button-touch-target-display)}.mat-mdc-raised-button:hover{box-shadow:var(--mdc-protected-button-hover-container-elevation-shadow)}.mat-mdc-raised-button:focus{box-shadow:var(--mdc-protected-button-focus-container-elevation-shadow)}.mat-mdc-raised-button:active,.mat-mdc-raised-button:focus:active{box-shadow:var(--mdc-protected-button-pressed-container-elevation-shadow)}.mat-mdc-raised-button[disabled],.mat-mdc-raised-button.mat-mdc-button-disabled{cursor:default;pointer-events:none;color:var(--mdc-protected-button-disabled-label-text-color);background-color:var(--mdc-protected-button-disabled-container-color)}.mat-mdc-raised-button[disabled].mat-mdc-button-disabled,.mat-mdc-raised-button.mat-mdc-button-disabled.mat-mdc-button-disabled{box-shadow:var(--mdc-protected-button-disabled-container-elevation-shadow)}.mat-mdc-raised-button.mat-mdc-button-disabled-interactive{pointer-events:auto}.mat-mdc-outlined-button{font-family:var(--mdc-outlined-button-label-text-font);font-size:var(--mdc-outlined-button-label-text-size);letter-spacing:var(--mdc-outlined-button-label-text-tracking);font-weight:var(--mdc-outlined-button-label-text-weight);text-transform:var(--mdc-outlined-button-label-text-transform);height:var(--mdc-outlined-button-container-height);border-radius:var(--mdc-outlined-button-container-shape);padding:0 15px 0 15px;border-width:var(--mdc-outlined-button-outline-width);padding:0 var(--mat-outlined-button-horizontal-padding, 15px)}.mat-mdc-outlined-button:not(:disabled){color:var(--mdc-outlined-button-label-text-color)}.mat-mdc-outlined-button:disabled{color:var(--mdc-outlined-button-disabled-label-text-color)}.mat-mdc-outlined-button .mdc-button__ripple{border-radius:var(--mdc-outlined-button-container-shape)}.mat-mdc-outlined-button:not(:disabled){border-color:var(--mdc-outlined-button-outline-color)}.mat-mdc-outlined-button:disabled{border-color:var(--mdc-outlined-button-disabled-outline-color)}.mat-mdc-outlined-button.mdc-button--icon-trailing{padding:0 11px 0 15px}.mat-mdc-outlined-button.mdc-button--icon-leading{padding:0 15px 0 11px}.mat-mdc-outlined-button .mdc-button__ripple{top:-1px;left:-1px;bottom:-1px;right:-1px;border-width:var(--mdc-outlined-button-outline-width)}.mat-mdc-outlined-button .mdc-button__touch{left:calc(-1 * var(--mdc-outlined-button-outline-width));width:calc(100% + 2 * var(--mdc-outlined-button-outline-width))}.mat-mdc-outlined-button>.mat-icon{margin-right:var(--mat-outlined-button-icon-spacing, 8px);margin-left:var(--mat-outlined-button-icon-offset, -4px)}[dir=rtl] .mat-mdc-outlined-button>.mat-icon{margin-right:var(--mat-outlined-button-icon-offset, -4px);margin-left:var(--mat-outlined-button-icon-spacing, 8px)}.mat-mdc-outlined-button .mdc-button__label+.mat-icon{margin-right:var(--mat-outlined-button-icon-offset, -4px);margin-left:var(--mat-outlined-button-icon-spacing, 8px)}[dir=rtl] .mat-mdc-outlined-button .mdc-button__label+.mat-icon{margin-right:var(--mat-outlined-button-icon-spacing, 8px);margin-left:var(--mat-outlined-button-icon-offset, -4px)}.mat-mdc-outlined-button .mat-ripple-element{background-color:var(--mat-outlined-button-ripple-color)}.mat-mdc-outlined-button .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-outlined-button-state-layer-color)}.mat-mdc-outlined-button.mat-mdc-button-disabled .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-outlined-button-disabled-state-layer-color)}.mat-mdc-outlined-button:hover .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-outlined-button-hover-state-layer-opacity)}.mat-mdc-outlined-button.cdk-program-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-outlined-button.cdk-keyboard-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-outlined-button.mat-mdc-button-disabled-interactive:focus .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-outlined-button-focus-state-layer-opacity)}.mat-mdc-outlined-button:active .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-outlined-button-pressed-state-layer-opacity)}.mat-mdc-outlined-button .mat-mdc-button-touch-target{position:absolute;top:50%;height:48px;left:0;right:0;transform:translateY(-50%);display:var(--mat-outlined-button-touch-target-display)}.mat-mdc-outlined-button[disabled],.mat-mdc-outlined-button.mat-mdc-button-disabled{cursor:default;pointer-events:none;color:var(--mdc-outlined-button-disabled-label-text-color);border-color:var(--mdc-outlined-button-disabled-outline-color)}.mat-mdc-outlined-button.mat-mdc-button-disabled-interactive{pointer-events:auto}.mat-mdc-button-base{text-decoration:none}.mat-mdc-button,.mat-mdc-unelevated-button,.mat-mdc-raised-button,.mat-mdc-outlined-button{-webkit-tap-highlight-color:rgba(0,0,0,0)}.mat-mdc-button .mat-mdc-button-ripple,.mat-mdc-button .mat-mdc-button-persistent-ripple,.mat-mdc-button .mat-mdc-button-persistent-ripple::before,.mat-mdc-unelevated-button .mat-mdc-button-ripple,.mat-mdc-unelevated-button .mat-mdc-button-persistent-ripple,.mat-mdc-unelevated-button .mat-mdc-button-persistent-ripple::before,.mat-mdc-raised-button .mat-mdc-button-ripple,.mat-mdc-raised-button .mat-mdc-button-persistent-ripple,.mat-mdc-raised-button .mat-mdc-button-persistent-ripple::before,.mat-mdc-outlined-button .mat-mdc-button-ripple,.mat-mdc-outlined-button .mat-mdc-button-persistent-ripple,.mat-mdc-outlined-button .mat-mdc-button-persistent-ripple::before{top:0;left:0;right:0;bottom:0;position:absolute;pointer-events:none;border-radius:inherit}.mat-mdc-button .mat-mdc-button-ripple,.mat-mdc-unelevated-button .mat-mdc-button-ripple,.mat-mdc-raised-button .mat-mdc-button-ripple,.mat-mdc-outlined-button .mat-mdc-button-ripple{overflow:hidden}.mat-mdc-button .mat-mdc-button-persistent-ripple::before,.mat-mdc-unelevated-button .mat-mdc-button-persistent-ripple::before,.mat-mdc-raised-button .mat-mdc-button-persistent-ripple::before,.mat-mdc-outlined-button .mat-mdc-button-persistent-ripple::before{content:"";opacity:0}.mat-mdc-button .mdc-button__label,.mat-mdc-unelevated-button .mdc-button__label,.mat-mdc-raised-button .mdc-button__label,.mat-mdc-outlined-button .mdc-button__label{z-index:1}.mat-mdc-button .mat-mdc-focus-indicator,.mat-mdc-unelevated-button .mat-mdc-focus-indicator,.mat-mdc-raised-button .mat-mdc-focus-indicator,.mat-mdc-outlined-button .mat-mdc-focus-indicator{top:0;left:0;right:0;bottom:0;position:absolute}.mat-mdc-button:focus .mat-mdc-focus-indicator::before,.mat-mdc-unelevated-button:focus .mat-mdc-focus-indicator::before,.mat-mdc-raised-button:focus .mat-mdc-focus-indicator::before,.mat-mdc-outlined-button:focus .mat-mdc-focus-indicator::before{content:""}.mat-mdc-button._mat-animation-noopable,.mat-mdc-unelevated-button._mat-animation-noopable,.mat-mdc-raised-button._mat-animation-noopable,.mat-mdc-outlined-button._mat-animation-noopable{transition:none !important;animation:none !important}.mat-mdc-button>.mat-icon,.mat-mdc-unelevated-button>.mat-icon,.mat-mdc-raised-button>.mat-icon,.mat-mdc-outlined-button>.mat-icon{display:inline-block;position:relative;vertical-align:top;font-size:1.125rem;height:1.125rem;width:1.125rem}.mat-mdc-outlined-button .mat-mdc-button-ripple,.mat-mdc-outlined-button .mdc-button__ripple{top:-1px;left:-1px;bottom:-1px;right:-1px;border-width:-1px}.mat-mdc-unelevated-button .mat-mdc-focus-indicator::before,.mat-mdc-raised-button .mat-mdc-focus-indicator::before{margin:calc(calc(var(--mat-mdc-focus-indicator-border-width, 3px) + 2px)*-1)}.mat-mdc-outlined-button .mat-mdc-focus-indicator::before{margin:calc(calc(var(--mat-mdc-focus-indicator-border-width, 3px) + 3px)*-1)}',
        '.cdk-high-contrast-active .mat-mdc-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-unelevated-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-raised-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-outlined-button:not(.mdc-button--outlined),.cdk-high-contrast-active .mat-mdc-icon-button{outline:solid 1px}',
      ],
      encapsulation: 2,
      changeDetection: 0,
    }));
  let i = t;
  return i;
})();
var ts = (() => {
  let t = class t extends Ja {
    constructor(e, n, r, a) {
      super(e, n, r, a),
        this._rippleLoader.configureRipple(this._elementRef.nativeElement, {
          centered: !0,
        });
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)(k(V), k(et), k(A), k(it, 8));
  }),
    (t.ɵcmp = P({
      type: t,
      selectors: [['button', 'mat-icon-button', '']],
      hostVars: 14,
      hostBindings: function (n, r) {
        n & 2 &&
          (Y('disabled', r._getDisabledAttribute())(
            'aria-disabled',
            r._getAriaDisabled()
          ),
          wt(r.color ? 'mat-' + r.color : ''),
          q('mat-mdc-button-disabled', r.disabled)(
            'mat-mdc-button-disabled-interactive',
            r.disabledInteractive
          )('_mat-animation-noopable', r._animationMode === 'NoopAnimations')(
            'mat-unthemed',
            !r.color
          )('mat-mdc-button-base', !0));
      },
      exportAs: ['matButton'],
      standalone: !0,
      features: [Fe, j],
      attrs: vl,
      ngContentSelectors: _l,
      decls: 4,
      vars: 0,
      consts: [
        [1, 'mat-mdc-button-persistent-ripple', 'mdc-icon-button__ripple'],
        [1, 'mat-mdc-focus-indicator'],
        [1, 'mat-mdc-button-touch-target'],
      ],
      template: function (n, r) {
        n & 1 && (pt(), F(0, 'span', 0), tt(1), F(2, 'span', 1)(3, 'span', 2));
      },
      styles: [
        '.mdc-icon-button{display:inline-block;position:relative;box-sizing:border-box;border:none;outline:none;background-color:rgba(0,0,0,0);fill:currentColor;color:inherit;text-decoration:none;cursor:pointer;user-select:none;z-index:0;overflow:visible}.mdc-icon-button .mdc-icon-button__touch{position:absolute;top:50%;height:48px;left:50%;width:48px;transform:translate(-50%, -50%)}@media screen and (forced-colors: active){.mdc-icon-button.mdc-ripple-upgraded--background-focused .mdc-icon-button__focus-ring,.mdc-icon-button:not(.mdc-ripple-upgraded):focus .mdc-icon-button__focus-ring{display:block}}.mdc-icon-button:disabled{cursor:default;pointer-events:none}.mdc-icon-button[hidden]{display:none}.mdc-icon-button--display-flex{align-items:center;display:inline-flex;justify-content:center}.mdc-icon-button__focus-ring{pointer-events:none;border:2px solid rgba(0,0,0,0);border-radius:6px;box-sizing:content-box;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:100%;width:100%;display:none}@media screen and (forced-colors: active){.mdc-icon-button__focus-ring{border-color:CanvasText}}.mdc-icon-button__focus-ring::after{content:"";border:2px solid rgba(0,0,0,0);border-radius:8px;display:block;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:calc(100% + 4px);width:calc(100% + 4px)}@media screen and (forced-colors: active){.mdc-icon-button__focus-ring::after{border-color:CanvasText}}.mdc-icon-button__icon{display:inline-block}.mdc-icon-button__icon.mdc-icon-button__icon--on{display:none}.mdc-icon-button--on .mdc-icon-button__icon{display:none}.mdc-icon-button--on .mdc-icon-button__icon.mdc-icon-button__icon--on{display:inline-block}.mdc-icon-button__link{height:100%;left:0;outline:none;position:absolute;top:0;width:100%}.mat-mdc-icon-button{color:var(--mdc-icon-button-icon-color)}.mat-mdc-icon-button .mdc-button__icon{font-size:var(--mdc-icon-button-icon-size)}.mat-mdc-icon-button svg,.mat-mdc-icon-button img{width:var(--mdc-icon-button-icon-size);height:var(--mdc-icon-button-icon-size)}.mat-mdc-icon-button:disabled{color:var(--mdc-icon-button-disabled-icon-color)}.mat-mdc-icon-button{border-radius:50%;flex-shrink:0;text-align:center;width:var(--mdc-icon-button-state-layer-size, 48px);height:var(--mdc-icon-button-state-layer-size, 48px);padding:calc(calc(var(--mdc-icon-button-state-layer-size, 48px) - var(--mdc-icon-button-icon-size, 24px)) / 2);font-size:var(--mdc-icon-button-icon-size);-webkit-tap-highlight-color:rgba(0,0,0,0)}.mat-mdc-icon-button svg{vertical-align:baseline}.mat-mdc-icon-button[disabled],.mat-mdc-icon-button.mat-mdc-button-disabled{cursor:default;pointer-events:none;color:var(--mdc-icon-button-disabled-icon-color)}.mat-mdc-icon-button.mat-mdc-button-disabled-interactive{pointer-events:auto}.mat-mdc-icon-button .mat-mdc-button-ripple,.mat-mdc-icon-button .mat-mdc-button-persistent-ripple,.mat-mdc-icon-button .mat-mdc-button-persistent-ripple::before{top:0;left:0;right:0;bottom:0;position:absolute;pointer-events:none;border-radius:inherit}.mat-mdc-icon-button .mat-mdc-button-ripple{overflow:hidden}.mat-mdc-icon-button .mat-mdc-button-persistent-ripple::before{content:"";opacity:0}.mat-mdc-icon-button .mdc-button__label{z-index:1}.mat-mdc-icon-button .mat-mdc-focus-indicator{top:0;left:0;right:0;bottom:0;position:absolute}.mat-mdc-icon-button:focus .mat-mdc-focus-indicator::before{content:""}.mat-mdc-icon-button .mat-ripple-element{background-color:var(--mat-icon-button-ripple-color)}.mat-mdc-icon-button .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-icon-button-state-layer-color)}.mat-mdc-icon-button.mat-mdc-button-disabled .mat-mdc-button-persistent-ripple::before{background-color:var(--mat-icon-button-disabled-state-layer-color)}.mat-mdc-icon-button:hover .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-icon-button-hover-state-layer-opacity)}.mat-mdc-icon-button.cdk-program-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-icon-button.cdk-keyboard-focused .mat-mdc-button-persistent-ripple::before,.mat-mdc-icon-button.mat-mdc-button-disabled-interactive:focus .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-icon-button-focus-state-layer-opacity)}.mat-mdc-icon-button:active .mat-mdc-button-persistent-ripple::before{opacity:var(--mat-icon-button-pressed-state-layer-opacity)}.mat-mdc-icon-button .mat-mdc-button-touch-target{position:absolute;top:50%;height:48px;left:50%;width:48px;transform:translate(-50%, -50%);display:var(--mat-icon-button-touch-target-display)}.mat-mdc-icon-button._mat-animation-noopable{transition:none !important;animation:none !important}.mat-mdc-icon-button .mat-mdc-button-persistent-ripple{border-radius:50%}.mat-mdc-icon-button.mat-unthemed:not(.mdc-ripple-upgraded):focus::before,.mat-mdc-icon-button.mat-primary:not(.mdc-ripple-upgraded):focus::before,.mat-mdc-icon-button.mat-accent:not(.mdc-ripple-upgraded):focus::before,.mat-mdc-icon-button.mat-warn:not(.mdc-ripple-upgraded):focus::before{background:rgba(0,0,0,0);opacity:1}',
        gl,
      ],
      encapsulation: 2,
      changeDetection: 0,
    }));
  let i = t;
  return i;
})();
var we = (() => {
  let t = class t {};
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵmod = N({ type: t })),
    (t.ɵinj = O({ imports: [$, xe, $] }));
  let i = t;
  return i;
})();
var wl = ['*'],
  Yi;
function kl() {
  if (Yi === void 0 && ((Yi = null), typeof window < 'u')) {
    let i = window;
    i.trustedTypes !== void 0 &&
      (Yi = i.trustedTypes.createPolicy('angular#components', {
        createHTML: (t) => t,
      }));
  }
  return Yi;
}
function ai(i) {
  return kl()?.createHTML(i) || i;
}
function is(i) {
  return Error(`Unable to find icon with the name "${i}"`);
}
function Cl() {
  return Error(
    'Could not find HttpClient provider for use with Angular Material icons. Please include the HttpClientModule from @angular/common/http in your app imports.'
  );
}
function ns(i) {
  return Error(
    `The URL provided to MatIconRegistry was not trusted as a resource URL via Angular's DomSanitizer. Attempted URL was "${i}".`
  );
}
function os(i) {
  return Error(
    `The literal provided to MatIconRegistry was not trusted as safe HTML by Angular's DomSanitizer. Attempted literal was "${i}".`
  );
}
var Dt = class {
    constructor(t, o, e) {
      (this.url = t), (this.svgText = o), (this.options = e);
    }
  },
  Il = (() => {
    let t = class t {
      constructor(e, n, r, a) {
        (this._httpClient = e),
          (this._sanitizer = n),
          (this._errorHandler = a),
          (this._svgIconConfigs = new Map()),
          (this._iconSetConfigs = new Map()),
          (this._cachedIconsByUrl = new Map()),
          (this._inProgressUrlFetches = new Map()),
          (this._fontCssClassesByAlias = new Map()),
          (this._resolvers = []),
          (this._defaultFontSetClass = ['material-icons', 'mat-ligature-font']),
          (this._document = r);
      }
      addSvgIcon(e, n, r) {
        return this.addSvgIconInNamespace('', e, n, r);
      }
      addSvgIconLiteral(e, n, r) {
        return this.addSvgIconLiteralInNamespace('', e, n, r);
      }
      addSvgIconInNamespace(e, n, r, a) {
        return this._addSvgIconConfig(e, n, new Dt(r, null, a));
      }
      addSvgIconResolver(e) {
        return this._resolvers.push(e), this;
      }
      addSvgIconLiteralInNamespace(e, n, r, a) {
        let s = this._sanitizer.sanitize(nt.HTML, r);
        if (!s) throw os(r);
        let c = ai(s);
        return this._addSvgIconConfig(e, n, new Dt('', c, a));
      }
      addSvgIconSet(e, n) {
        return this.addSvgIconSetInNamespace('', e, n);
      }
      addSvgIconSetLiteral(e, n) {
        return this.addSvgIconSetLiteralInNamespace('', e, n);
      }
      addSvgIconSetInNamespace(e, n, r) {
        return this._addSvgIconSetConfig(e, new Dt(n, null, r));
      }
      addSvgIconSetLiteralInNamespace(e, n, r) {
        let a = this._sanitizer.sanitize(nt.HTML, n);
        if (!a) throw os(n);
        let s = ai(a);
        return this._addSvgIconSetConfig(e, new Dt('', s, r));
      }
      registerFontClassAlias(e, n = e) {
        return this._fontCssClassesByAlias.set(e, n), this;
      }
      classNameForFontAlias(e) {
        return this._fontCssClassesByAlias.get(e) || e;
      }
      setDefaultFontSetClass(...e) {
        return (this._defaultFontSetClass = e), this;
      }
      getDefaultFontSetClass() {
        return this._defaultFontSetClass;
      }
      getSvgIconFromUrl(e) {
        let n = this._sanitizer.sanitize(nt.RESOURCE_URL, e);
        if (!n) throw ns(e);
        let r = this._cachedIconsByUrl.get(n);
        return r
          ? b(Xi(r))
          : this._loadSvgIconFromConfig(new Dt(e, null)).pipe(
              R((a) => this._cachedIconsByUrl.set(n, a)),
              x((a) => Xi(a))
            );
      }
      getNamedSvgIcon(e, n = '') {
        let r = rs(n, e),
          a = this._svgIconConfigs.get(r);
        if (a) return this._getSvgFromConfig(a);
        if (((a = this._getIconConfigFromResolvers(n, e)), a))
          return this._svgIconConfigs.set(r, a), this._getSvgFromConfig(a);
        let s = this._iconSetConfigs.get(n);
        return s ? this._getSvgFromIconSetConfigs(e, s) : Bt(is(r));
      }
      ngOnDestroy() {
        (this._resolvers = []),
          this._svgIconConfigs.clear(),
          this._iconSetConfigs.clear(),
          this._cachedIconsByUrl.clear();
      }
      _getSvgFromConfig(e) {
        return e.svgText
          ? b(Xi(this._svgElementFromConfig(e)))
          : this._loadSvgIconFromConfig(e).pipe(x((n) => Xi(n)));
      }
      _getSvgFromIconSetConfigs(e, n) {
        let r = this._extractIconWithNameFromAnySet(e, n);
        if (r) return b(r);
        let a = n
          .filter((s) => !s.svgText)
          .map((s) =>
            this._loadSvgIconSetFromConfig(s).pipe(
              St((c) => {
                let l = `Loading icon set URL: ${this._sanitizer.sanitize(nt.RESOURCE_URL, s.url)} failed: ${c.message}`;
                return this._errorHandler.handleError(new Error(l)), b(null);
              })
            )
          );
        return qo(a).pipe(
          x(() => {
            let s = this._extractIconWithNameFromAnySet(e, n);
            if (!s) throw is(e);
            return s;
          })
        );
      }
      _extractIconWithNameFromAnySet(e, n) {
        for (let r = n.length - 1; r >= 0; r--) {
          let a = n[r];
          if (a.svgText && a.svgText.toString().indexOf(e) > -1) {
            let s = this._svgElementFromConfig(a),
              c = this._extractSvgIconFromSet(s, e, a.options);
            if (c) return c;
          }
        }
        return null;
      }
      _loadSvgIconFromConfig(e) {
        return this._fetchIcon(e).pipe(
          R((n) => (e.svgText = n)),
          x(() => this._svgElementFromConfig(e))
        );
      }
      _loadSvgIconSetFromConfig(e) {
        return e.svgText
          ? b(null)
          : this._fetchIcon(e).pipe(R((n) => (e.svgText = n)));
      }
      _extractSvgIconFromSet(e, n, r) {
        let a = e.querySelector(`[id="${n}"]`);
        if (!a) return null;
        let s = a.cloneNode(!0);
        if ((s.removeAttribute('id'), s.nodeName.toLowerCase() === 'svg'))
          return this._setSvgAttributes(s, r);
        if (s.nodeName.toLowerCase() === 'symbol')
          return this._setSvgAttributes(this._toSvgElement(s), r);
        let c = this._svgElementFromString(ai('<svg></svg>'));
        return c.appendChild(s), this._setSvgAttributes(c, r);
      }
      _svgElementFromString(e) {
        let n = this._document.createElement('DIV');
        n.innerHTML = e;
        let r = n.querySelector('svg');
        if (!r) throw Error('<svg> tag not found');
        return r;
      }
      _toSvgElement(e) {
        let n = this._svgElementFromString(ai('<svg></svg>')),
          r = e.attributes;
        for (let a = 0; a < r.length; a++) {
          let { name: s, value: c } = r[a];
          s !== 'id' && n.setAttribute(s, c);
        }
        for (let a = 0; a < e.childNodes.length; a++)
          e.childNodes[a].nodeType === this._document.ELEMENT_NODE &&
            n.appendChild(e.childNodes[a].cloneNode(!0));
        return n;
      }
      _setSvgAttributes(e, n) {
        return (
          e.setAttribute('fit', ''),
          e.setAttribute('height', '100%'),
          e.setAttribute('width', '100%'),
          e.setAttribute('preserveAspectRatio', 'xMidYMid meet'),
          e.setAttribute('focusable', 'false'),
          n && n.viewBox && e.setAttribute('viewBox', n.viewBox),
          e
        );
      }
      _fetchIcon(e) {
        let { url: n, options: r } = e,
          a = r?.withCredentials ?? !1;
        if (!this._httpClient) throw Cl();
        if (n == null) throw Error(`Cannot fetch icon from URL "${n}".`);
        let s = this._sanitizer.sanitize(nt.RESOURCE_URL, n);
        if (!s) throw ns(n);
        let c = this._inProgressUrlFetches.get(s);
        if (c) return c;
        let d = this._httpClient
          .get(s, { responseType: 'text', withCredentials: a })
          .pipe(
            x((l) => ai(l)),
            Ht(() => this._inProgressUrlFetches.delete(s)),
            Yo()
          );
        return this._inProgressUrlFetches.set(s, d), d;
      }
      _addSvgIconConfig(e, n, r) {
        return this._svgIconConfigs.set(rs(e, n), r), this;
      }
      _addSvgIconSetConfig(e, n) {
        let r = this._iconSetConfigs.get(e);
        return r ? r.push(n) : this._iconSetConfigs.set(e, [n]), this;
      }
      _svgElementFromConfig(e) {
        if (!e.svgElement) {
          let n = this._svgElementFromString(e.svgText);
          this._setSvgAttributes(n, e.options), (e.svgElement = n);
        }
        return e.svgElement;
      }
      _getIconConfigFromResolvers(e, n) {
        for (let r = 0; r < this._resolvers.length; r++) {
          let a = this._resolvers[r](n, e);
          if (a)
            return El(a) ? new Dt(a.url, null, a.options) : new Dt(a, null);
        }
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(f(Vr, 8), f(Vn), f(S, 8), f(qt));
    }),
      (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
    let i = t;
    return i;
  })();
function Xi(i) {
  return i.cloneNode(!0);
}
function rs(i, t) {
  return i + ':' + t;
}
function El(i) {
  return !!(i.url && i.options);
}
var Dl = new C('MAT_ICON_DEFAULT_OPTIONS'),
  Al = new C('mat-icon-location', { providedIn: 'root', factory: Ml });
function Ml() {
  let i = h(S),
    t = i ? i.location : null;
  return { getPathname: () => (t ? t.pathname + t.search : '') };
}
var as = [
    'clip-path',
    'color-profile',
    'src',
    'cursor',
    'fill',
    'filter',
    'marker',
    'marker-start',
    'marker-mid',
    'marker-end',
    'mask',
    'stroke',
  ],
  Tl = as.map((i) => `[${i}]`).join(', '),
  Sl = /^url\(['"]?#(.*?)['"]?\)$/,
  Ji = (() => {
    let t = class t {
      get color() {
        return this._color || this._defaultColor;
      }
      set color(e) {
        this._color = e;
      }
      get svgIcon() {
        return this._svgIcon;
      }
      set svgIcon(e) {
        e !== this._svgIcon &&
          (e
            ? this._updateSvgIcon(e)
            : this._svgIcon && this._clearSvgElement(),
          (this._svgIcon = e));
      }
      get fontSet() {
        return this._fontSet;
      }
      set fontSet(e) {
        let n = this._cleanupFontValue(e);
        n !== this._fontSet &&
          ((this._fontSet = n), this._updateFontIconClasses());
      }
      get fontIcon() {
        return this._fontIcon;
      }
      set fontIcon(e) {
        let n = this._cleanupFontValue(e);
        n !== this._fontIcon &&
          ((this._fontIcon = n), this._updateFontIconClasses());
      }
      constructor(e, n, r, a, s, c) {
        (this._elementRef = e),
          (this._iconRegistry = n),
          (this._location = a),
          (this._errorHandler = s),
          (this.inline = !1),
          (this._previousFontSetClass = []),
          (this._currentIconFetch = ke.EMPTY),
          c &&
            (c.color && (this.color = this._defaultColor = c.color),
            c.fontSet && (this.fontSet = c.fontSet)),
          r || e.nativeElement.setAttribute('aria-hidden', 'true');
      }
      _splitIconName(e) {
        if (!e) return ['', ''];
        let n = e.split(':');
        switch (n.length) {
          case 1:
            return ['', n[0]];
          case 2:
            return n;
          default:
            throw Error(`Invalid icon name: "${e}"`);
        }
      }
      ngOnInit() {
        this._updateFontIconClasses();
      }
      ngAfterViewChecked() {
        let e = this._elementsWithExternalReferences;
        if (e && e.size) {
          let n = this._location.getPathname();
          n !== this._previousPath &&
            ((this._previousPath = n), this._prependPathToReferences(n));
        }
      }
      ngOnDestroy() {
        this._currentIconFetch.unsubscribe(),
          this._elementsWithExternalReferences &&
            this._elementsWithExternalReferences.clear();
      }
      _usingFontIcon() {
        return !this.svgIcon;
      }
      _setSvgElement(e) {
        this._clearSvgElement();
        let n = this._location.getPathname();
        (this._previousPath = n),
          this._cacheChildrenWithExternalReferences(e),
          this._prependPathToReferences(n),
          this._elementRef.nativeElement.appendChild(e);
      }
      _clearSvgElement() {
        let e = this._elementRef.nativeElement,
          n = e.childNodes.length;
        for (
          this._elementsWithExternalReferences &&
          this._elementsWithExternalReferences.clear();
          n--;

        ) {
          let r = e.childNodes[n];
          (r.nodeType !== 1 || r.nodeName.toLowerCase() === 'svg') &&
            r.remove();
        }
      }
      _updateFontIconClasses() {
        if (!this._usingFontIcon()) return;
        let e = this._elementRef.nativeElement,
          n = (
            this.fontSet
              ? this._iconRegistry
                  .classNameForFontAlias(this.fontSet)
                  .split(/ +/)
              : this._iconRegistry.getDefaultFontSetClass()
          ).filter((r) => r.length > 0);
        this._previousFontSetClass.forEach((r) => e.classList.remove(r)),
          n.forEach((r) => e.classList.add(r)),
          (this._previousFontSetClass = n),
          this.fontIcon !== this._previousFontIconClass &&
            !n.includes('mat-ligature-font') &&
            (this._previousFontIconClass &&
              e.classList.remove(this._previousFontIconClass),
            this.fontIcon && e.classList.add(this.fontIcon),
            (this._previousFontIconClass = this.fontIcon));
      }
      _cleanupFontValue(e) {
        return typeof e == 'string' ? e.trim().split(' ')[0] : e;
      }
      _prependPathToReferences(e) {
        let n = this._elementsWithExternalReferences;
        n &&
          n.forEach((r, a) => {
            r.forEach((s) => {
              a.setAttribute(s.name, `url('${e}#${s.value}')`);
            });
          });
      }
      _cacheChildrenWithExternalReferences(e) {
        let n = e.querySelectorAll(Tl),
          r = (this._elementsWithExternalReferences =
            this._elementsWithExternalReferences || new Map());
        for (let a = 0; a < n.length; a++)
          as.forEach((s) => {
            let c = n[a],
              d = c.getAttribute(s),
              l = d ? d.match(Sl) : null;
            if (l) {
              let m = r.get(c);
              m || ((m = []), r.set(c, m)), m.push({ name: s, value: l[1] });
            }
          });
      }
      _updateSvgIcon(e) {
        if (
          ((this._svgNamespace = null),
          (this._svgName = null),
          this._currentIconFetch.unsubscribe(),
          e)
        ) {
          let [n, r] = this._splitIconName(e);
          n && (this._svgNamespace = n),
            r && (this._svgName = r),
            (this._currentIconFetch = this._iconRegistry
              .getNamedSvgIcon(r, n)
              .pipe(vt(1))
              .subscribe(
                (a) => this._setSvgElement(a),
                (a) => {
                  let s = `Error retrieving icon ${n}:${r}! ${a.message}`;
                  this._errorHandler.handleError(new Error(s));
                }
              ));
        }
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(
        k(V),
        k(Il),
        Ot('aria-hidden'),
        k(Al),
        k(qt),
        k(Dl, 8)
      );
    }),
      (t.ɵcmp = P({
        type: t,
        selectors: [['mat-icon']],
        hostAttrs: ['role', 'img', 1, 'mat-icon', 'notranslate'],
        hostVars: 10,
        hostBindings: function (n, r) {
          n & 2 &&
            (Y('data-mat-icon-type', r._usingFontIcon() ? 'font' : 'svg')(
              'data-mat-icon-name',
              r._svgName || r.fontIcon
            )('data-mat-icon-namespace', r._svgNamespace || r.fontSet)(
              'fontIcon',
              r._usingFontIcon() ? r.fontIcon : null
            ),
            wt(r.color ? 'mat-' + r.color : ''),
            q('mat-icon-inline', r.inline)(
              'mat-icon-no-color',
              r.color !== 'primary' &&
                r.color !== 'accent' &&
                r.color !== 'warn'
            ));
        },
        inputs: {
          color: 'color',
          inline: [w.HasDecoratorInputTransform, 'inline', 'inline', T],
          svgIcon: 'svgIcon',
          fontSet: 'fontSet',
          fontIcon: 'fontIcon',
        },
        exportAs: ['matIcon'],
        standalone: !0,
        features: [ot, j],
        ngContentSelectors: wl,
        decls: 1,
        vars: 0,
        template: function (n, r) {
          n & 1 && (pt(), tt(0));
        },
        styles: [
          'mat-icon,mat-icon.mat-primary,mat-icon.mat-accent,mat-icon.mat-warn{color:var(--mat-icon-color)}.mat-icon{-webkit-user-select:none;user-select:none;background-repeat:no-repeat;display:inline-block;fill:currentColor;height:24px;width:24px;overflow:hidden}.mat-icon.mat-icon-inline{font-size:inherit;height:inherit;line-height:inherit;width:inherit}.mat-icon.mat-ligature-font[fontIcon]::before{content:attr(fontIcon)}[dir=rtl] .mat-icon-rtl-mirror{transform:scale(-1, 1)}.mat-form-field:not(.mat-form-field-appearance-legacy) .mat-form-field-prefix .mat-icon,.mat-form-field:not(.mat-form-field-appearance-legacy) .mat-form-field-suffix .mat-icon{display:block}.mat-form-field:not(.mat-form-field-appearance-legacy) .mat-form-field-prefix .mat-icon-button .mat-icon,.mat-form-field:not(.mat-form-field-appearance-legacy) .mat-form-field-suffix .mat-icon-button .mat-icon{margin:auto}',
        ],
        encapsulation: 2,
        changeDetection: 0,
      }));
    let i = t;
    return i;
  })(),
  tn = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵmod = N({ type: t })),
      (t.ɵinj = O({ imports: [$, $] }));
    let i = t;
    return i;
  })();
var Rl = ['fileInput'];
function Fl(i, t) {
  if (i & 1) {
    let o = Nt();
    v(0, 'div', 3)(1, 'button', 4),
      W('click', function () {
        H(o), Pt();
        let n = _i(2);
        return G(n.click());
      }),
      D(2, ' Select JSON File '),
      g(),
      v(3, 'span', 5),
      D(4, 'Drop file here to upload'),
      g()();
  }
}
function Ol(i, t) {
  if (i & 1) {
    let o = Nt();
    v(0, 'div', 6)(1, 'mat-icon', 7),
      D(2, 'description'),
      g(),
      v(3, 'span', 8),
      D(4),
      g(),
      v(5, 'button', 9),
      W('click', function () {
        H(o);
        let n = Pt();
        return G(n.file.set(null));
      }),
      v(6, 'mat-icon'),
      D(7, 'close'),
      g()()();
  }
  if (i & 2) {
    let o,
      e = Pt();
    L(4), ce((o = e.file()) == null ? null : o.name);
  }
}
var cs = (() => {
  let t = class t {
    constructor() {
      (this.file = Re(null)),
        _n(() => {
          this.file() ||
            (this.fileInput && (this.fileInput.nativeElement.value = ''));
        });
    }
    onFileSelected(e) {
      let n = e.target.files[0];
      console.log(n), this.file.set(n);
    }
    onFileDrop(e) {
      e.preventDefault();
      let n = e.dataTransfer?.files;
      if (n && n.length > 0) {
        let r = n[0];
        console.log(r);
      }
    }
    onDragOver(e) {
      e.preventDefault(), e.stopPropagation();
    }
    onDragLeave(e) {
      e.preventDefault(), e.stopPropagation();
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵcmp = P({
      type: t,
      selectors: [['app-uploader']],
      viewQuery: function (n, r) {
        if ((n & 1 && yt(Rl, 5), n & 2)) {
          let a;
          rt((a = at())) && (r.fileInput = a.first);
        }
      },
      standalone: !0,
      features: [j],
      decls: 5,
      vars: 1,
      consts: [
        ['fileInput', ''],
        [
          1,
          'flex',
          'flex-col',
          'rounded-md',
          'border',
          'border-slate-200',
          'select-none',
          3,
          'drop',
          'dragover',
          'dragleave',
        ],
        ['type', 'file', 'accept', '.json', 1, 'hidden', 3, 'change'],
        [1, 'flex', 'justify-between', 'items-center', 'p-4', 'pl-2'],
        ['mat-stroked-button', '', 3, 'click'],
        [1, 'text-gray-700', 'text-sm'],
        [1, 'flex', 'gap-2', 'items-center', 'p-2'],
        ['fontIcon', 'text_snippet'],
        [1, 'text-gray-800', 'flex-1'],
        ['mat-icon-button', '', 3, 'click'],
      ],
      template: function (n, r) {
        if (n & 1) {
          let a = Nt();
          v(0, 'div', 1),
            W('drop', function (c) {
              return H(a), G(r.onFileDrop(c));
            })('dragover', function (c) {
              return H(a), G(r.onDragOver(c));
            })('dragleave', function (c) {
              return H(a), G(r.onDragLeave(c));
            }),
            v(1, 'input', 2, 0),
            W('change', function (c) {
              return H(a), G(r.onFileSelected(c));
            }),
            g(),
            fi(3, Fl, 5, 0, 'div', 3)(4, Ol, 8, 1),
            g();
        }
        n & 2 && (L(3), bi(3, r.file() ? 4 : 3));
      },
      dependencies: [tn, Ji, we, Qi, ts],
      encapsulation: 2,
      changeDetection: 0,
    }));
  let i = t;
  return i;
})();
var ds = (() => {
  let t = class t {
    constructor() {
      this._listeners = [];
    }
    notify(e, n) {
      for (let r of this._listeners) r(e, n);
    }
    listen(e) {
      return (
        this._listeners.push(e),
        () => {
          this._listeners = this._listeners.filter((n) => e !== n);
        }
      );
    }
    ngOnDestroy() {
      this._listeners = [];
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵprov = _({ token: t, factory: t.ɵfac, providedIn: 'root' }));
  let i = t;
  return i;
})();
var en = new C('');
var ls = new C('');
var Pl = {
    '[class.ng-untouched]': 'isUntouched',
    '[class.ng-touched]': 'isTouched',
    '[class.ng-pristine]': 'isPristine',
    '[class.ng-dirty]': 'isDirty',
    '[class.ng-valid]': 'isValid',
    '[class.ng-invalid]': 'isInvalid',
    '[class.ng-pending]': 'isPending',
  },
  pp = U(u({}, Pl), { '[class.ng-submitted]': 'isSubmitted' });
var Vl = ['input'],
  jl = ['formField'],
  Ll = ['*'],
  us = 0,
  nn = class {
    constructor(t, o) {
      (this.source = t), (this.value = o);
    }
  },
  Ul = { provide: en, useExisting: oe(() => Uo), multi: !0 },
  hs = new C('MatRadioGroup'),
  zl = new C('mat-radio-default-options', { providedIn: 'root', factory: Bl });
function Bl() {
  return { color: 'accent' };
}
var Uo = (() => {
    let t = class t {
      get name() {
        return this._name;
      }
      set name(e) {
        (this._name = e), this._updateRadioButtonNames();
      }
      get labelPosition() {
        return this._labelPosition;
      }
      set labelPosition(e) {
        (this._labelPosition = e === 'before' ? 'before' : 'after'),
          this._markRadiosForCheck();
      }
      get value() {
        return this._value;
      }
      set value(e) {
        this._value !== e &&
          ((this._value = e),
          this._updateSelectedRadioFromValue(),
          this._checkSelectedRadioButton());
      }
      _checkSelectedRadioButton() {
        this._selected &&
          !this._selected.checked &&
          (this._selected.checked = !0);
      }
      get selected() {
        return this._selected;
      }
      set selected(e) {
        (this._selected = e),
          (this.value = e ? e.value : null),
          this._checkSelectedRadioButton();
      }
      get disabled() {
        return this._disabled;
      }
      set disabled(e) {
        (this._disabled = e), this._markRadiosForCheck();
      }
      get required() {
        return this._required;
      }
      set required(e) {
        (this._required = e), this._markRadiosForCheck();
      }
      constructor(e) {
        (this._changeDetector = e),
          (this._value = null),
          (this._name = `mat-radio-group-${us++}`),
          (this._selected = null),
          (this._isInitialized = !1),
          (this._labelPosition = 'after'),
          (this._disabled = !1),
          (this._required = !1),
          (this._controlValueAccessorChangeFn = () => {}),
          (this.onTouched = () => {}),
          (this.change = new Q());
      }
      ngAfterContentInit() {
        (this._isInitialized = !0),
          (this._buttonChanges = this._radios.changes.subscribe(() => {
            this.selected &&
              !this._radios.find((e) => e === this.selected) &&
              (this._selected = null);
          }));
      }
      ngOnDestroy() {
        this._buttonChanges?.unsubscribe();
      }
      _touch() {
        this.onTouched && this.onTouched();
      }
      _updateRadioButtonNames() {
        this._radios &&
          this._radios.forEach((e) => {
            (e.name = this.name), e._markForCheck();
          });
      }
      _updateSelectedRadioFromValue() {
        let e = this._selected !== null && this._selected.value === this._value;
        this._radios &&
          !e &&
          ((this._selected = null),
          this._radios.forEach((n) => {
            (n.checked = this.value === n.value),
              n.checked && (this._selected = n);
          }));
      }
      _emitChangeEvent() {
        this._isInitialized &&
          this.change.emit(new nn(this._selected, this._value));
      }
      _markRadiosForCheck() {
        this._radios && this._radios.forEach((e) => e._markForCheck());
      }
      writeValue(e) {
        (this.value = e), this._changeDetector.markForCheck();
      }
      registerOnChange(e) {
        this._controlValueAccessorChangeFn = e;
      }
      registerOnTouched(e) {
        this.onTouched = e;
      }
      setDisabledState(e) {
        (this.disabled = e), this._changeDetector.markForCheck();
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(k(xt));
    }),
      (t.ɵdir = mt({
        type: t,
        selectors: [['mat-radio-group']],
        contentQueries: function (n, r, a) {
          if ((n & 1 && vi(a, on, 5), n & 2)) {
            let s;
            rt((s = at())) && (r._radios = s);
          }
        },
        hostAttrs: ['role', 'radiogroup', 1, 'mat-mdc-radio-group'],
        inputs: {
          color: 'color',
          name: 'name',
          labelPosition: 'labelPosition',
          value: 'value',
          selected: 'selected',
          disabled: [w.HasDecoratorInputTransform, 'disabled', 'disabled', T],
          required: [w.HasDecoratorInputTransform, 'required', 'required', T],
        },
        outputs: { change: 'change' },
        exportAs: ['matRadioGroup'],
        standalone: !0,
        features: [Wt([Ul, { provide: hs, useExisting: t }]), ot],
      }));
    let i = t;
    return i;
  })(),
  on = (() => {
    let t = class t {
      get checked() {
        return this._checked;
      }
      set checked(e) {
        this._checked !== e &&
          ((this._checked = e),
          e && this.radioGroup && this.radioGroup.value !== this.value
            ? (this.radioGroup.selected = this)
            : !e &&
              this.radioGroup &&
              this.radioGroup.value === this.value &&
              (this.radioGroup.selected = null),
          e && this._radioDispatcher.notify(this.id, this.name),
          this._changeDetector.markForCheck());
      }
      get value() {
        return this._value;
      }
      set value(e) {
        this._value !== e &&
          ((this._value = e),
          this.radioGroup !== null &&
            (this.checked || (this.checked = this.radioGroup.value === e),
            this.checked && (this.radioGroup.selected = this)));
      }
      get labelPosition() {
        return (
          this._labelPosition ||
          (this.radioGroup && this.radioGroup.labelPosition) ||
          'after'
        );
      }
      set labelPosition(e) {
        this._labelPosition = e;
      }
      get disabled() {
        return (
          this._disabled ||
          (this.radioGroup !== null && this.radioGroup.disabled)
        );
      }
      set disabled(e) {
        this._setDisabled(e);
      }
      get required() {
        return this._required || (this.radioGroup && this.radioGroup.required);
      }
      set required(e) {
        this._required = e;
      }
      get color() {
        return (
          this._color ||
          (this.radioGroup && this.radioGroup.color) ||
          (this._providerOverride && this._providerOverride.color) ||
          'accent'
        );
      }
      set color(e) {
        this._color = e;
      }
      get inputId() {
        return `${this.id || this._uniqueId}-input`;
      }
      constructor(e, n, r, a, s, c, d, l) {
        (this._elementRef = n),
          (this._changeDetector = r),
          (this._focusMonitor = a),
          (this._radioDispatcher = s),
          (this._providerOverride = d),
          (this._uniqueId = `mat-radio-${++us}`),
          (this.id = this._uniqueId),
          (this.disableRipple = !1),
          (this.tabIndex = 0),
          (this.change = new Q()),
          (this._checked = !1),
          (this._value = null),
          (this._removeUniqueSelectionListener = () => {}),
          (this.radioGroup = e),
          (this._noopAnimations = c === 'NoopAnimations'),
          l && (this.tabIndex = Kt(l, 0));
      }
      focus(e, n) {
        n
          ? this._focusMonitor.focusVia(this._inputElement, n, e)
          : this._inputElement.nativeElement.focus(e);
      }
      _markForCheck() {
        this._changeDetector.markForCheck();
      }
      ngOnInit() {
        this.radioGroup &&
          ((this.checked = this.radioGroup.value === this._value),
          this.checked && (this.radioGroup.selected = this),
          (this.name = this.radioGroup.name)),
          (this._removeUniqueSelectionListener = this._radioDispatcher.listen(
            (e, n) => {
              e !== this.id && n === this.name && (this.checked = !1);
            }
          ));
      }
      ngDoCheck() {
        this._updateTabIndex();
      }
      ngAfterViewInit() {
        this._updateTabIndex(),
          this._focusMonitor.monitor(this._elementRef, !0).subscribe((e) => {
            !e && this.radioGroup && this.radioGroup._touch();
          });
      }
      ngOnDestroy() {
        this._focusMonitor.stopMonitoring(this._elementRef),
          this._removeUniqueSelectionListener();
      }
      _emitChangeEvent() {
        this.change.emit(new nn(this, this._value));
      }
      _isRippleDisabled() {
        return this.disableRipple || this.disabled;
      }
      _onInputClick(e) {
        e.stopPropagation();
      }
      _onInputInteraction(e) {
        if ((e.stopPropagation(), !this.checked && !this.disabled)) {
          let n = this.radioGroup && this.value !== this.radioGroup.value;
          (this.checked = !0),
            this._emitChangeEvent(),
            this.radioGroup &&
              (this.radioGroup._controlValueAccessorChangeFn(this.value),
              n && this.radioGroup._emitChangeEvent());
        }
      }
      _onTouchTargetClick(e) {
        this._onInputInteraction(e),
          this.disabled || this._inputElement.nativeElement.focus();
      }
      _setDisabled(e) {
        this._disabled !== e &&
          ((this._disabled = e), this._changeDetector.markForCheck());
      }
      _updateTabIndex() {
        let e = this.radioGroup,
          n;
        if (
          (!e || !e.selected || this.disabled
            ? (n = this.tabIndex)
            : (n = e.selected === this ? this.tabIndex : -1),
          n !== this._previousTabIndex)
        ) {
          let r = this._inputElement?.nativeElement;
          r &&
            (r.setAttribute('tabindex', n + ''), (this._previousTabIndex = n));
        }
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(
        k(hs, 8),
        k(V),
        k(xt),
        k(Wi),
        k(ds),
        k(it, 8),
        k(zl, 8),
        Ot('tabindex')
      );
    }),
      (t.ɵcmp = P({
        type: t,
        selectors: [['mat-radio-button']],
        viewQuery: function (n, r) {
          if ((n & 1 && (yt(Vl, 5), yt(jl, 7, V)), n & 2)) {
            let a;
            rt((a = at())) && (r._inputElement = a.first),
              rt((a = at())) && (r._rippleTrigger = a.first);
          }
        },
        hostAttrs: [1, 'mat-mdc-radio-button'],
        hostVars: 15,
        hostBindings: function (n, r) {
          n & 1 &&
            W('focus', function () {
              return r._inputElement.nativeElement.focus();
            }),
            n & 2 &&
              (Y('id', r.id)('tabindex', null)('aria-label', null)(
                'aria-labelledby',
                null
              )('aria-describedby', null),
              q('mat-primary', r.color === 'primary')(
                'mat-accent',
                r.color === 'accent'
              )('mat-warn', r.color === 'warn')(
                'mat-mdc-radio-checked',
                r.checked
              )('_mat-animation-noopable', r._noopAnimations));
        },
        inputs: {
          id: 'id',
          name: 'name',
          ariaLabel: [w.None, 'aria-label', 'ariaLabel'],
          ariaLabelledby: [w.None, 'aria-labelledby', 'ariaLabelledby'],
          ariaDescribedby: [w.None, 'aria-describedby', 'ariaDescribedby'],
          disableRipple: [
            w.HasDecoratorInputTransform,
            'disableRipple',
            'disableRipple',
            T,
          ],
          tabIndex: [
            w.HasDecoratorInputTransform,
            'tabIndex',
            'tabIndex',
            (e) => (e == null ? 0 : Kt(e)),
          ],
          checked: [w.HasDecoratorInputTransform, 'checked', 'checked', T],
          value: 'value',
          labelPosition: 'labelPosition',
          disabled: [w.HasDecoratorInputTransform, 'disabled', 'disabled', T],
          required: [w.HasDecoratorInputTransform, 'required', 'required', T],
          color: 'color',
        },
        outputs: { change: 'change' },
        exportAs: ['matRadioButton'],
        standalone: !0,
        features: [ot, j],
        ngContentSelectors: Ll,
        decls: 13,
        vars: 16,
        consts: [
          ['formField', ''],
          ['input', ''],
          ['mat-internal-form-field', '', 3, 'labelPosition'],
          [1, 'mdc-radio'],
          [1, 'mat-mdc-radio-touch-target', 3, 'click'],
          [
            'type',
            'radio',
            1,
            'mdc-radio__native-control',
            3,
            'change',
            'id',
            'checked',
            'disabled',
            'required',
          ],
          [1, 'mdc-radio__background'],
          [1, 'mdc-radio__outer-circle'],
          [1, 'mdc-radio__inner-circle'],
          [
            'mat-ripple',
            '',
            1,
            'mat-radio-ripple',
            'mat-mdc-focus-indicator',
            3,
            'matRippleTrigger',
            'matRippleDisabled',
            'matRippleCentered',
          ],
          [1, 'mat-ripple-element', 'mat-radio-persistent-ripple'],
          [1, 'mdc-label', 3, 'for'],
        ],
        template: function (n, r) {
          if (n & 1) {
            let a = Nt();
            pt(),
              v(0, 'div', 2, 0)(2, 'div', 3)(3, 'div', 4),
              W('click', function (c) {
                return H(a), G(r._onTouchTargetClick(c));
              }),
              g(),
              v(4, 'input', 5, 1),
              W('change', function (c) {
                return H(a), G(r._onInputInteraction(c));
              }),
              g(),
              v(6, 'div', 6),
              F(7, 'div', 7)(8, 'div', 8),
              g(),
              v(9, 'div', 9),
              F(10, 'div', 10),
              g()(),
              v(11, 'label', 11),
              tt(12),
              g()();
          }
          n & 2 &&
            (J('labelPosition', r.labelPosition),
            L(2),
            q('mdc-radio--disabled', r.disabled),
            L(2),
            J('id', r.inputId)('checked', r.checked)('disabled', r.disabled)(
              'required',
              r.required
            ),
            Y('name', r.name)('value', r.value)('aria-label', r.ariaLabel)(
              'aria-labelledby',
              r.ariaLabelledby
            )('aria-describedby', r.ariaDescribedby),
            L(5),
            J('matRippleTrigger', r._rippleTrigger.nativeElement)(
              'matRippleDisabled',
              r._isRippleDisabled()
            )('matRippleCentered', !0),
            L(2),
            J('for', r.inputId));
        },
        dependencies: [ye, Zi],
        styles: [
          '.mdc-radio{display:inline-block;position:relative;flex:0 0 auto;box-sizing:content-box;width:20px;height:20px;cursor:pointer;will-change:opacity,transform,border-color,color}.mdc-radio[hidden]{display:none}.mdc-radio__background{display:inline-block;position:relative;box-sizing:border-box;width:20px;height:20px}.mdc-radio__background::before{position:absolute;transform:scale(0, 0);border-radius:50%;opacity:0;pointer-events:none;content:"";transition:opacity 120ms 0ms cubic-bezier(0.4, 0, 0.6, 1),transform 120ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-radio__outer-circle{position:absolute;top:0;left:0;box-sizing:border-box;width:100%;height:100%;border-width:2px;border-style:solid;border-radius:50%;transition:border-color 120ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-radio__inner-circle{position:absolute;top:0;left:0;box-sizing:border-box;width:100%;height:100%;transform:scale(0, 0);border-width:10px;border-style:solid;border-radius:50%;transition:transform 120ms 0ms cubic-bezier(0.4, 0, 0.6, 1),border-color 120ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-radio__native-control{position:absolute;margin:0;padding:0;opacity:0;cursor:inherit;z-index:1}.mdc-radio--touch{margin-top:4px;margin-bottom:4px;margin-right:4px;margin-left:4px}.mdc-radio--touch .mdc-radio__native-control{top:calc((40px - 48px) / 2);right:calc((40px - 48px) / 2);left:calc((40px - 48px) / 2);width:48px;height:48px}.mdc-radio.mdc-ripple-upgraded--background-focused .mdc-radio__focus-ring,.mdc-radio:not(.mdc-ripple-upgraded):focus .mdc-radio__focus-ring{pointer-events:none;border:2px solid rgba(0,0,0,0);border-radius:6px;box-sizing:content-box;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:100%;width:100%}@media screen and (forced-colors: active){.mdc-radio.mdc-ripple-upgraded--background-focused .mdc-radio__focus-ring,.mdc-radio:not(.mdc-ripple-upgraded):focus .mdc-radio__focus-ring{border-color:CanvasText}}.mdc-radio.mdc-ripple-upgraded--background-focused .mdc-radio__focus-ring::after,.mdc-radio:not(.mdc-ripple-upgraded):focus .mdc-radio__focus-ring::after{content:"";border:2px solid rgba(0,0,0,0);border-radius:8px;display:block;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:calc(100% + 4px);width:calc(100% + 4px)}@media screen and (forced-colors: active){.mdc-radio.mdc-ripple-upgraded--background-focused .mdc-radio__focus-ring::after,.mdc-radio:not(.mdc-ripple-upgraded):focus .mdc-radio__focus-ring::after{border-color:CanvasText}}.mdc-radio__native-control:checked+.mdc-radio__background,.mdc-radio__native-control:disabled+.mdc-radio__background{transition:opacity 120ms 0ms cubic-bezier(0, 0, 0.2, 1),transform 120ms 0ms cubic-bezier(0, 0, 0.2, 1)}.mdc-radio__native-control:checked+.mdc-radio__background .mdc-radio__outer-circle,.mdc-radio__native-control:disabled+.mdc-radio__background .mdc-radio__outer-circle{transition:border-color 120ms 0ms cubic-bezier(0, 0, 0.2, 1)}.mdc-radio__native-control:checked+.mdc-radio__background .mdc-radio__inner-circle,.mdc-radio__native-control:disabled+.mdc-radio__background .mdc-radio__inner-circle{transition:transform 120ms 0ms cubic-bezier(0, 0, 0.2, 1),border-color 120ms 0ms cubic-bezier(0, 0, 0.2, 1)}.mdc-radio--disabled{cursor:default;pointer-events:none}.mdc-radio__native-control:checked+.mdc-radio__background .mdc-radio__inner-circle{transform:scale(0.5);transition:transform 120ms 0ms cubic-bezier(0, 0, 0.2, 1),border-color 120ms 0ms cubic-bezier(0, 0, 0.2, 1)}.mdc-radio__native-control:disabled+.mdc-radio__background,[aria-disabled=true] .mdc-radio__native-control+.mdc-radio__background{cursor:default}.mdc-radio__native-control:focus+.mdc-radio__background::before{transform:scale(1);opacity:.12;transition:opacity 120ms 0ms cubic-bezier(0, 0, 0.2, 1),transform 120ms 0ms cubic-bezier(0, 0, 0.2, 1)}.mat-mdc-radio-button{-webkit-tap-highlight-color:rgba(0,0,0,0)}.mat-mdc-radio-button .mdc-radio{padding:calc((var(--mdc-radio-state-layer-size) - 20px) / 2)}.mat-mdc-radio-button .mdc-radio [aria-disabled=true] .mdc-radio__native-control:checked+.mdc-radio__background .mdc-radio__outer-circle,.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:disabled:checked+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-disabled-selected-icon-color)}.mat-mdc-radio-button .mdc-radio [aria-disabled=true] .mdc-radio__native-control+.mdc-radio__background .mdc-radio__inner-circle,.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:disabled+.mdc-radio__background .mdc-radio__inner-circle{border-color:var(--mdc-radio-disabled-selected-icon-color)}.mat-mdc-radio-button .mdc-radio [aria-disabled=true] .mdc-radio__native-control:checked+.mdc-radio__background .mdc-radio__outer-circle,.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:disabled:checked+.mdc-radio__background .mdc-radio__outer-circle{opacity:var(--mdc-radio-disabled-selected-icon-opacity)}.mat-mdc-radio-button .mdc-radio [aria-disabled=true] .mdc-radio__native-control+.mdc-radio__background .mdc-radio__inner-circle,.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:disabled+.mdc-radio__background .mdc-radio__inner-circle{opacity:var(--mdc-radio-disabled-selected-icon-opacity)}.mat-mdc-radio-button .mdc-radio [aria-disabled=true] .mdc-radio__native-control:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle,.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:disabled:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-disabled-unselected-icon-color)}.mat-mdc-radio-button .mdc-radio [aria-disabled=true] .mdc-radio__native-control:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle,.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:disabled:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle{opacity:var(--mdc-radio-disabled-unselected-icon-opacity)}.mat-mdc-radio-button .mdc-radio.mdc-ripple-upgraded--background-focused .mdc-radio__native-control:enabled:checked+.mdc-radio__background .mdc-radio__outer-circle,.mat-mdc-radio-button .mdc-radio:not(.mdc-ripple-upgraded):focus .mdc-radio__native-control:enabled:checked+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-selected-focus-icon-color)}.mat-mdc-radio-button .mdc-radio.mdc-ripple-upgraded--background-focused .mdc-radio__native-control:enabled+.mdc-radio__background .mdc-radio__inner-circle,.mat-mdc-radio-button .mdc-radio:not(.mdc-ripple-upgraded):focus .mdc-radio__native-control:enabled+.mdc-radio__background .mdc-radio__inner-circle{border-color:var(--mdc-radio-selected-focus-icon-color)}.mat-mdc-radio-button .mdc-radio:hover .mdc-radio__native-control:enabled:checked+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-selected-hover-icon-color)}.mat-mdc-radio-button .mdc-radio:hover .mdc-radio__native-control:enabled+.mdc-radio__background .mdc-radio__inner-circle{border-color:var(--mdc-radio-selected-hover-icon-color)}.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:enabled:checked+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-selected-icon-color)}.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:enabled+.mdc-radio__background .mdc-radio__inner-circle{border-color:var(--mdc-radio-selected-icon-color)}.mat-mdc-radio-button .mdc-radio:not(:disabled):active .mdc-radio__native-control:enabled:checked+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-selected-pressed-icon-color)}.mat-mdc-radio-button .mdc-radio:not(:disabled):active .mdc-radio__native-control:enabled+.mdc-radio__background .mdc-radio__inner-circle{border-color:var(--mdc-radio-selected-pressed-icon-color)}.mat-mdc-radio-button .mdc-radio:hover .mdc-radio__native-control:enabled:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-unselected-hover-icon-color)}.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:enabled:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-unselected-icon-color)}.mat-mdc-radio-button .mdc-radio:not(:disabled):active .mdc-radio__native-control:enabled:not(:checked)+.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-unselected-pressed-icon-color)}.mat-mdc-radio-button .mdc-radio .mdc-radio__background::before{top:calc(-1 * (var(--mdc-radio-state-layer-size) - 20px) / 2);left:calc(-1 * (var(--mdc-radio-state-layer-size) - 20px) / 2);width:var(--mdc-radio-state-layer-size);height:var(--mdc-radio-state-layer-size)}.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control{top:calc((var(--mdc-radio-state-layer-size) - var(--mdc-radio-state-layer-size)) / 2);right:calc((var(--mdc-radio-state-layer-size) - var(--mdc-radio-state-layer-size)) / 2);left:calc((var(--mdc-radio-state-layer-size) - var(--mdc-radio-state-layer-size)) / 2);width:var(--mdc-radio-state-layer-size);height:var(--mdc-radio-state-layer-size)}.mat-mdc-radio-button .mdc-radio .mdc-radio__background::before{background-color:var(--mat-radio-ripple-color)}.mat-mdc-radio-button .mdc-radio:hover .mdc-radio__native-control:not([disabled]):not(:focus)~.mdc-radio__background::before{opacity:.04;transform:scale(1)}.mat-mdc-radio-button.mat-mdc-radio-checked .mdc-radio__background::before{background-color:var(--mat-radio-checked-ripple-color)}.mat-mdc-radio-button.mat-mdc-radio-checked .mat-ripple-element{background-color:var(--mat-radio-checked-ripple-color)}.mat-mdc-radio-button .mdc-radio--disabled+label{color:var(--mat-radio-disabled-label-color)}.mat-mdc-radio-button .mat-radio-ripple{top:0;left:0;right:0;bottom:0;position:absolute;pointer-events:none;border-radius:50%}.mat-mdc-radio-button .mat-radio-ripple .mat-ripple-element{opacity:.14}.mat-mdc-radio-button .mat-radio-ripple::before{border-radius:50%}.mat-mdc-radio-button._mat-animation-noopable .mdc-radio__background::before,.mat-mdc-radio-button._mat-animation-noopable .mdc-radio__outer-circle,.mat-mdc-radio-button._mat-animation-noopable .mdc-radio__inner-circle{transition:none !important}.mat-mdc-radio-button .mdc-radio .mdc-radio__native-control:focus:enabled:not(:checked)~.mdc-radio__background .mdc-radio__outer-circle{border-color:var(--mdc-radio-unselected-focus-icon-color, black)}.mat-mdc-radio-button.cdk-focused .mat-mdc-focus-indicator::before{content:""}.mat-mdc-radio-touch-target{position:absolute;top:50%;height:48px;left:50%;width:48px;transform:translate(-50%, -50%);display:var(--mat-radio-touch-target-display)}[dir=rtl] .mat-mdc-radio-touch-target{left:0;right:50%;transform:translate(50%, -50%)}',
        ],
        encapsulation: 2,
        changeDetection: 0,
      }));
    let i = t;
    return i;
  })(),
  ms = (() => {
    let t = class t {};
    (t.ɵfac = function (n) {
      return new (n || t)();
    }),
      (t.ɵmod = N({ type: t })),
      (t.ɵinj = O({ imports: [$, wn, xe, on, $] }));
    let i = t;
    return i;
  })();
var Gl = new C('mat-chips-default-options', {
  providedIn: 'root',
  factory: () => ({ separatorKeyCodes: [13] }),
});
var ps = (() => {
  let t = class t {};
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵmod = N({ type: t })),
    (t.ɵinj = O({
      providers: [Xa, { provide: Gl, useValue: { separatorKeyCodes: [13] } }],
      imports: [$, xe, $],
    }));
  let i = t;
  return i;
})();
var ql = ['input'],
  Wl = ['label'],
  Kl = ['*'],
  Zl = new C('mat-checkbox-default-options', {
    providedIn: 'root',
    factory: bs,
  });
function bs() {
  return { color: 'accent', clickAction: 'check-indeterminate' };
}
var K = (function (i) {
    return (
      (i[(i.Init = 0)] = 'Init'),
      (i[(i.Checked = 1)] = 'Checked'),
      (i[(i.Unchecked = 2)] = 'Unchecked'),
      (i[(i.Indeterminate = 3)] = 'Indeterminate'),
      i
    );
  })(K || {}),
  Ql = { provide: en, useExisting: oe(() => rn), multi: !0 },
  zo = class {},
  Yl = 0,
  fs = bs(),
  rn = (() => {
    let t = class t {
      focus() {
        this._inputElement.nativeElement.focus();
      }
      _createChangeEvent(e) {
        let n = new zo();
        return (n.source = this), (n.checked = e), n;
      }
      _getAnimationTargetElement() {
        return this._inputElement?.nativeElement;
      }
      get inputId() {
        return `${this.id || this._uniqueId}-input`;
      }
      constructor(e, n, r, a, s, c) {
        (this._elementRef = e),
          (this._changeDetectorRef = n),
          (this._ngZone = r),
          (this._animationMode = s),
          (this._options = c),
          (this._animationClasses = {
            uncheckedToChecked: 'mdc-checkbox--anim-unchecked-checked',
            uncheckedToIndeterminate:
              'mdc-checkbox--anim-unchecked-indeterminate',
            checkedToUnchecked: 'mdc-checkbox--anim-checked-unchecked',
            checkedToIndeterminate: 'mdc-checkbox--anim-checked-indeterminate',
            indeterminateToChecked: 'mdc-checkbox--anim-indeterminate-checked',
            indeterminateToUnchecked:
              'mdc-checkbox--anim-indeterminate-unchecked',
          }),
          (this.ariaLabel = ''),
          (this.ariaLabelledby = null),
          (this.labelPosition = 'after'),
          (this.name = null),
          (this.change = new Q()),
          (this.indeterminateChange = new Q()),
          (this._onTouched = () => {}),
          (this._currentAnimationClass = ''),
          (this._currentCheckState = K.Init),
          (this._controlValueAccessorChangeFn = () => {}),
          (this._validatorChangeFn = () => {}),
          (this._checked = !1),
          (this._disabled = !1),
          (this._indeterminate = !1),
          (this._options = this._options || fs),
          (this.color = this._options.color || fs.color),
          (this.tabIndex = parseInt(a) || 0),
          (this.id = this._uniqueId = `mat-mdc-checkbox-${++Yl}`);
      }
      ngOnChanges(e) {
        e.required && this._validatorChangeFn();
      }
      ngAfterViewInit() {
        this._syncIndeterminate(this._indeterminate);
      }
      get checked() {
        return this._checked;
      }
      set checked(e) {
        e != this.checked &&
          ((this._checked = e), this._changeDetectorRef.markForCheck());
      }
      get disabled() {
        return this._disabled;
      }
      set disabled(e) {
        e !== this.disabled &&
          ((this._disabled = e), this._changeDetectorRef.markForCheck());
      }
      get indeterminate() {
        return this._indeterminate;
      }
      set indeterminate(e) {
        let n = e != this._indeterminate;
        (this._indeterminate = e),
          n &&
            (this._indeterminate
              ? this._transitionCheckState(K.Indeterminate)
              : this._transitionCheckState(
                  this.checked ? K.Checked : K.Unchecked
                ),
            this.indeterminateChange.emit(this._indeterminate)),
          this._syncIndeterminate(this._indeterminate);
      }
      _isRippleDisabled() {
        return this.disableRipple || this.disabled;
      }
      _onLabelTextChange() {
        this._changeDetectorRef.detectChanges();
      }
      writeValue(e) {
        this.checked = !!e;
      }
      registerOnChange(e) {
        this._controlValueAccessorChangeFn = e;
      }
      registerOnTouched(e) {
        this._onTouched = e;
      }
      setDisabledState(e) {
        this.disabled = e;
      }
      validate(e) {
        return this.required && e.value !== !0 ? { required: !0 } : null;
      }
      registerOnValidatorChange(e) {
        this._validatorChangeFn = e;
      }
      _transitionCheckState(e) {
        let n = this._currentCheckState,
          r = this._getAnimationTargetElement();
        if (
          !(n === e || !r) &&
          (this._currentAnimationClass &&
            r.classList.remove(this._currentAnimationClass),
          (this._currentAnimationClass =
            this._getAnimationClassForCheckStateTransition(n, e)),
          (this._currentCheckState = e),
          this._currentAnimationClass.length > 0)
        ) {
          r.classList.add(this._currentAnimationClass);
          let a = this._currentAnimationClass;
          this._ngZone.runOutsideAngular(() => {
            setTimeout(() => {
              r.classList.remove(a);
            }, 1e3);
          });
        }
      }
      _emitChangeEvent() {
        this._controlValueAccessorChangeFn(this.checked),
          this.change.emit(this._createChangeEvent(this.checked)),
          this._inputElement &&
            (this._inputElement.nativeElement.checked = this.checked);
      }
      toggle() {
        (this.checked = !this.checked),
          this._controlValueAccessorChangeFn(this.checked);
      }
      _handleInputClick() {
        let e = this._options?.clickAction;
        !this.disabled && e !== 'noop'
          ? (this.indeterminate &&
              e !== 'check' &&
              Promise.resolve().then(() => {
                (this._indeterminate = !1),
                  this.indeterminateChange.emit(this._indeterminate);
              }),
            (this._checked = !this._checked),
            this._transitionCheckState(this._checked ? K.Checked : K.Unchecked),
            this._emitChangeEvent())
          : !this.disabled &&
            e === 'noop' &&
            ((this._inputElement.nativeElement.checked = this.checked),
            (this._inputElement.nativeElement.indeterminate =
              this.indeterminate));
      }
      _onInteractionEvent(e) {
        e.stopPropagation();
      }
      _onBlur() {
        Promise.resolve().then(() => {
          this._onTouched(), this._changeDetectorRef.markForCheck();
        });
      }
      _getAnimationClassForCheckStateTransition(e, n) {
        if (this._animationMode === 'NoopAnimations') return '';
        switch (e) {
          case K.Init:
            if (n === K.Checked)
              return this._animationClasses.uncheckedToChecked;
            if (n == K.Indeterminate)
              return this._checked
                ? this._animationClasses.checkedToIndeterminate
                : this._animationClasses.uncheckedToIndeterminate;
            break;
          case K.Unchecked:
            return n === K.Checked
              ? this._animationClasses.uncheckedToChecked
              : this._animationClasses.uncheckedToIndeterminate;
          case K.Checked:
            return n === K.Unchecked
              ? this._animationClasses.checkedToUnchecked
              : this._animationClasses.checkedToIndeterminate;
          case K.Indeterminate:
            return n === K.Checked
              ? this._animationClasses.indeterminateToChecked
              : this._animationClasses.indeterminateToUnchecked;
        }
        return '';
      }
      _syncIndeterminate(e) {
        let n = this._inputElement;
        n && (n.nativeElement.indeterminate = e);
      }
      _onInputClick() {
        this._handleInputClick();
      }
      _onTouchTargetClick() {
        this._handleInputClick(),
          this.disabled || this._inputElement.nativeElement.focus();
      }
      _preventBubblingFromLabel(e) {
        e.target &&
          this._labelElement.nativeElement.contains(e.target) &&
          e.stopPropagation();
      }
    };
    (t.ɵfac = function (n) {
      return new (n || t)(
        k(V),
        k(xt),
        k(A),
        Ot('tabindex'),
        k(it, 8),
        k(Zl, 8)
      );
    }),
      (t.ɵcmp = P({
        type: t,
        selectors: [['mat-checkbox']],
        viewQuery: function (n, r) {
          if ((n & 1 && (yt(ql, 5), yt(Wl, 5), yt(ye, 5)), n & 2)) {
            let a;
            rt((a = at())) && (r._inputElement = a.first),
              rt((a = at())) && (r._labelElement = a.first),
              rt((a = at())) && (r.ripple = a.first);
          }
        },
        hostAttrs: [1, 'mat-mdc-checkbox'],
        hostVars: 14,
        hostBindings: function (n, r) {
          n & 2 &&
            (gi('id', r.id),
            Y('tabindex', null)('aria-label', null)('aria-labelledby', null),
            wt(r.color ? 'mat-' + r.color : 'mat-accent'),
            q('_mat-animation-noopable', r._animationMode === 'NoopAnimations')(
              'mdc-checkbox--disabled',
              r.disabled
            )('mat-mdc-checkbox-disabled', r.disabled)(
              'mat-mdc-checkbox-checked',
              r.checked
            ));
        },
        inputs: {
          ariaLabel: [w.None, 'aria-label', 'ariaLabel'],
          ariaLabelledby: [w.None, 'aria-labelledby', 'ariaLabelledby'],
          ariaDescribedby: [w.None, 'aria-describedby', 'ariaDescribedby'],
          id: 'id',
          required: [w.HasDecoratorInputTransform, 'required', 'required', T],
          labelPosition: 'labelPosition',
          name: 'name',
          value: 'value',
          disableRipple: [
            w.HasDecoratorInputTransform,
            'disableRipple',
            'disableRipple',
            T,
          ],
          tabIndex: [
            w.HasDecoratorInputTransform,
            'tabIndex',
            'tabIndex',
            (e) => (e == null ? void 0 : Kt(e)),
          ],
          color: 'color',
          checked: [w.HasDecoratorInputTransform, 'checked', 'checked', T],
          disabled: [w.HasDecoratorInputTransform, 'disabled', 'disabled', T],
          indeterminate: [
            w.HasDecoratorInputTransform,
            'indeterminate',
            'indeterminate',
            T,
          ],
        },
        outputs: {
          change: 'change',
          indeterminateChange: 'indeterminateChange',
        },
        exportAs: ['matCheckbox'],
        standalone: !0,
        features: [
          Wt([Ql, { provide: ls, useExisting: t, multi: !0 }]),
          ot,
          re,
          j,
        ],
        ngContentSelectors: Kl,
        decls: 15,
        vars: 19,
        consts: [
          ['checkbox', ''],
          ['input', ''],
          ['label', ''],
          ['mat-internal-form-field', '', 3, 'click', 'labelPosition'],
          [1, 'mdc-checkbox'],
          [1, 'mat-mdc-checkbox-touch-target', 3, 'click'],
          [
            'type',
            'checkbox',
            1,
            'mdc-checkbox__native-control',
            3,
            'blur',
            'click',
            'change',
            'checked',
            'indeterminate',
            'disabled',
            'id',
            'required',
            'tabIndex',
          ],
          [1, 'mdc-checkbox__ripple'],
          [1, 'mdc-checkbox__background'],
          [
            'focusable',
            'false',
            'viewBox',
            '0 0 24 24',
            'aria-hidden',
            'true',
            1,
            'mdc-checkbox__checkmark',
          ],
          [
            'fill',
            'none',
            'd',
            'M1.73,12.91 8.1,19.28 22.79,4.59',
            1,
            'mdc-checkbox__checkmark-path',
          ],
          [1, 'mdc-checkbox__mixedmark'],
          [
            'mat-ripple',
            '',
            1,
            'mat-mdc-checkbox-ripple',
            'mat-mdc-focus-indicator',
            3,
            'matRippleTrigger',
            'matRippleDisabled',
            'matRippleCentered',
          ],
          [1, 'mdc-label', 3, 'for'],
        ],
        template: function (n, r) {
          if (n & 1) {
            let a = Nt();
            pt(),
              v(0, 'div', 3),
              W('click', function (c) {
                return H(a), G(r._preventBubblingFromLabel(c));
              }),
              v(1, 'div', 4, 0)(3, 'div', 5),
              W('click', function () {
                return H(a), G(r._onTouchTargetClick());
              }),
              g(),
              v(4, 'input', 6, 1),
              W('blur', function () {
                return H(a), G(r._onBlur());
              })('click', function () {
                return H(a), G(r._onInputClick());
              })('change', function (c) {
                return H(a), G(r._onInteractionEvent(c));
              }),
              g(),
              F(6, 'div', 7),
              v(7, 'div', 8),
              De(),
              v(8, 'svg', 9),
              F(9, 'path', 10),
              g(),
              li(),
              F(10, 'div', 11),
              g(),
              F(11, 'div', 12),
              g(),
              v(12, 'label', 13, 2),
              tt(14),
              g()();
          }
          if (n & 2) {
            let a = _i(2);
            J('labelPosition', r.labelPosition),
              L(4),
              q('mdc-checkbox--selected', r.checked),
              J('checked', r.checked)('indeterminate', r.indeterminate)(
                'disabled',
                r.disabled
              )('id', r.inputId)('required', r.required)(
                'tabIndex',
                r.disabled ? -1 : r.tabIndex
              ),
              Y('aria-label', r.ariaLabel || null)(
                'aria-labelledby',
                r.ariaLabelledby
              )('aria-describedby', r.ariaDescribedby)(
                'aria-checked',
                r.indeterminate ? 'mixed' : null
              )('name', r.name)('value', r.value),
              L(7),
              J('matRippleTrigger', a)(
                'matRippleDisabled',
                r.disableRipple || r.disabled
              )('matRippleCentered', !0),
              L(),
              J('for', r.inputId);
          }
        },
        dependencies: [ye, Zi],
        styles: [
          '.mdc-touch-target-wrapper{display:inline}@keyframes mdc-checkbox-unchecked-checked-checkmark-path{0%,50%{stroke-dashoffset:29.7833385}50%{animation-timing-function:cubic-bezier(0, 0, 0.2, 1)}100%{stroke-dashoffset:0}}@keyframes mdc-checkbox-unchecked-indeterminate-mixedmark{0%,68.2%{transform:scaleX(0)}68.2%{animation-timing-function:cubic-bezier(0, 0, 0, 1)}100%{transform:scaleX(1)}}@keyframes mdc-checkbox-checked-unchecked-checkmark-path{from{animation-timing-function:cubic-bezier(0.4, 0, 1, 1);opacity:1;stroke-dashoffset:0}to{opacity:0;stroke-dashoffset:-29.7833385}}@keyframes mdc-checkbox-checked-indeterminate-checkmark{from{animation-timing-function:cubic-bezier(0, 0, 0.2, 1);transform:rotate(0deg);opacity:1}to{transform:rotate(45deg);opacity:0}}@keyframes mdc-checkbox-indeterminate-checked-checkmark{from{animation-timing-function:cubic-bezier(0.14, 0, 0, 1);transform:rotate(45deg);opacity:0}to{transform:rotate(360deg);opacity:1}}@keyframes mdc-checkbox-checked-indeterminate-mixedmark{from{animation-timing-function:mdc-animation-deceleration-curve-timing-function;transform:rotate(-45deg);opacity:0}to{transform:rotate(0deg);opacity:1}}@keyframes mdc-checkbox-indeterminate-checked-mixedmark{from{animation-timing-function:cubic-bezier(0.14, 0, 0, 1);transform:rotate(0deg);opacity:1}to{transform:rotate(315deg);opacity:0}}@keyframes mdc-checkbox-indeterminate-unchecked-mixedmark{0%{animation-timing-function:linear;transform:scaleX(1);opacity:1}32.8%,100%{transform:scaleX(0);opacity:0}}.mdc-checkbox{display:inline-block;position:relative;flex:0 0 18px;box-sizing:content-box;width:18px;height:18px;line-height:0;white-space:nowrap;cursor:pointer;vertical-align:bottom}.mdc-checkbox[hidden]{display:none}.mdc-checkbox.mdc-ripple-upgraded--background-focused .mdc-checkbox__focus-ring,.mdc-checkbox:not(.mdc-ripple-upgraded):focus .mdc-checkbox__focus-ring{pointer-events:none;border:2px solid rgba(0,0,0,0);border-radius:6px;box-sizing:content-box;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:100%;width:100%}@media screen and (forced-colors: active){.mdc-checkbox.mdc-ripple-upgraded--background-focused .mdc-checkbox__focus-ring,.mdc-checkbox:not(.mdc-ripple-upgraded):focus .mdc-checkbox__focus-ring{border-color:CanvasText}}.mdc-checkbox.mdc-ripple-upgraded--background-focused .mdc-checkbox__focus-ring::after,.mdc-checkbox:not(.mdc-ripple-upgraded):focus .mdc-checkbox__focus-ring::after{content:"";border:2px solid rgba(0,0,0,0);border-radius:8px;display:block;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);height:calc(100% + 4px);width:calc(100% + 4px)}@media screen and (forced-colors: active){.mdc-checkbox.mdc-ripple-upgraded--background-focused .mdc-checkbox__focus-ring::after,.mdc-checkbox:not(.mdc-ripple-upgraded):focus .mdc-checkbox__focus-ring::after{border-color:CanvasText}}@media all and (-ms-high-contrast: none){.mdc-checkbox .mdc-checkbox__focus-ring{display:none}}@media screen and (forced-colors: active),(-ms-high-contrast: active){.mdc-checkbox__mixedmark{margin:0 1px}}.mdc-checkbox--disabled{cursor:default;pointer-events:none}.mdc-checkbox__background{display:inline-flex;position:absolute;align-items:center;justify-content:center;box-sizing:border-box;width:18px;height:18px;border:2px solid currentColor;border-radius:2px;background-color:rgba(0,0,0,0);pointer-events:none;will-change:background-color,border-color;transition:background-color 90ms 0ms cubic-bezier(0.4, 0, 0.6, 1),border-color 90ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-checkbox__checkmark{position:absolute;top:0;right:0;bottom:0;left:0;width:100%;opacity:0;transition:opacity 180ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-checkbox--upgraded .mdc-checkbox__checkmark{opacity:1}.mdc-checkbox__checkmark-path{transition:stroke-dashoffset 180ms 0ms cubic-bezier(0.4, 0, 0.6, 1);stroke:currentColor;stroke-width:3.12px;stroke-dashoffset:29.7833385;stroke-dasharray:29.7833385}.mdc-checkbox__mixedmark{width:100%;height:0;transform:scaleX(0) rotate(0deg);border-width:1px;border-style:solid;opacity:0;transition:opacity 90ms 0ms cubic-bezier(0.4, 0, 0.6, 1),transform 90ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-checkbox--anim-unchecked-checked .mdc-checkbox__background,.mdc-checkbox--anim-unchecked-indeterminate .mdc-checkbox__background,.mdc-checkbox--anim-checked-unchecked .mdc-checkbox__background,.mdc-checkbox--anim-indeterminate-unchecked .mdc-checkbox__background{animation-duration:180ms;animation-timing-function:linear}.mdc-checkbox--anim-unchecked-checked .mdc-checkbox__checkmark-path{animation:mdc-checkbox-unchecked-checked-checkmark-path 180ms linear 0s;transition:none}.mdc-checkbox--anim-unchecked-indeterminate .mdc-checkbox__mixedmark{animation:mdc-checkbox-unchecked-indeterminate-mixedmark 90ms linear 0s;transition:none}.mdc-checkbox--anim-checked-unchecked .mdc-checkbox__checkmark-path{animation:mdc-checkbox-checked-unchecked-checkmark-path 90ms linear 0s;transition:none}.mdc-checkbox--anim-checked-indeterminate .mdc-checkbox__checkmark{animation:mdc-checkbox-checked-indeterminate-checkmark 90ms linear 0s;transition:none}.mdc-checkbox--anim-checked-indeterminate .mdc-checkbox__mixedmark{animation:mdc-checkbox-checked-indeterminate-mixedmark 90ms linear 0s;transition:none}.mdc-checkbox--anim-indeterminate-checked .mdc-checkbox__checkmark{animation:mdc-checkbox-indeterminate-checked-checkmark 500ms linear 0s;transition:none}.mdc-checkbox--anim-indeterminate-checked .mdc-checkbox__mixedmark{animation:mdc-checkbox-indeterminate-checked-mixedmark 500ms linear 0s;transition:none}.mdc-checkbox--anim-indeterminate-unchecked .mdc-checkbox__mixedmark{animation:mdc-checkbox-indeterminate-unchecked-mixedmark 300ms linear 0s;transition:none}.mdc-checkbox__native-control:checked~.mdc-checkbox__background,.mdc-checkbox__native-control:indeterminate~.mdc-checkbox__background,.mdc-checkbox__native-control[data-indeterminate=true]~.mdc-checkbox__background{transition:border-color 90ms 0ms cubic-bezier(0, 0, 0.2, 1),background-color 90ms 0ms cubic-bezier(0, 0, 0.2, 1)}.mdc-checkbox__native-control:checked~.mdc-checkbox__background .mdc-checkbox__checkmark-path,.mdc-checkbox__native-control:indeterminate~.mdc-checkbox__background .mdc-checkbox__checkmark-path,.mdc-checkbox__native-control[data-indeterminate=true]~.mdc-checkbox__background .mdc-checkbox__checkmark-path{stroke-dashoffset:0}.mdc-checkbox__native-control{position:absolute;margin:0;padding:0;opacity:0;cursor:inherit}.mdc-checkbox__native-control:disabled{cursor:default;pointer-events:none}.mdc-checkbox--touch{margin:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2)}.mdc-checkbox--touch .mdc-checkbox__native-control{top:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2);right:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2);left:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2);width:var(--mdc-checkbox-state-layer-size);height:var(--mdc-checkbox-state-layer-size)}.mdc-checkbox__native-control:checked~.mdc-checkbox__background .mdc-checkbox__checkmark{transition:opacity 180ms 0ms cubic-bezier(0, 0, 0.2, 1),transform 180ms 0ms cubic-bezier(0, 0, 0.2, 1);opacity:1}.mdc-checkbox__native-control:checked~.mdc-checkbox__background .mdc-checkbox__mixedmark{transform:scaleX(1) rotate(-45deg)}.mdc-checkbox__native-control:indeterminate~.mdc-checkbox__background .mdc-checkbox__checkmark,.mdc-checkbox__native-control[data-indeterminate=true]~.mdc-checkbox__background .mdc-checkbox__checkmark{transform:rotate(45deg);opacity:0;transition:opacity 90ms 0ms cubic-bezier(0.4, 0, 0.6, 1),transform 90ms 0ms cubic-bezier(0.4, 0, 0.6, 1)}.mdc-checkbox__native-control:indeterminate~.mdc-checkbox__background .mdc-checkbox__mixedmark,.mdc-checkbox__native-control[data-indeterminate=true]~.mdc-checkbox__background .mdc-checkbox__mixedmark{transform:scaleX(1) rotate(0deg);opacity:1}.mdc-checkbox.mdc-checkbox--upgraded .mdc-checkbox__background,.mdc-checkbox.mdc-checkbox--upgraded .mdc-checkbox__checkmark,.mdc-checkbox.mdc-checkbox--upgraded .mdc-checkbox__checkmark-path,.mdc-checkbox.mdc-checkbox--upgraded .mdc-checkbox__mixedmark{transition:none}.mdc-checkbox{padding:calc((var(--mdc-checkbox-state-layer-size) - 18px) / 2);margin:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2)}.mdc-checkbox .mdc-checkbox__native-control[disabled]:not(:checked):not(:indeterminate):not([data-indeterminate=true])~.mdc-checkbox__background{border-color:var(--mdc-checkbox-disabled-unselected-icon-color);background-color:transparent}.mdc-checkbox .mdc-checkbox__native-control[disabled]:checked~.mdc-checkbox__background,.mdc-checkbox .mdc-checkbox__native-control[disabled]:indeterminate~.mdc-checkbox__background,.mdc-checkbox .mdc-checkbox__native-control[data-indeterminate=true][disabled]~.mdc-checkbox__background{border-color:transparent;background-color:var(--mdc-checkbox-disabled-selected-icon-color)}.mdc-checkbox .mdc-checkbox__native-control:enabled~.mdc-checkbox__background .mdc-checkbox__checkmark{color:var(--mdc-checkbox-selected-checkmark-color)}.mdc-checkbox .mdc-checkbox__native-control:enabled~.mdc-checkbox__background .mdc-checkbox__mixedmark{border-color:var(--mdc-checkbox-selected-checkmark-color)}.mdc-checkbox .mdc-checkbox__native-control:disabled~.mdc-checkbox__background .mdc-checkbox__checkmark{color:var(--mdc-checkbox-disabled-selected-checkmark-color)}.mdc-checkbox .mdc-checkbox__native-control:disabled~.mdc-checkbox__background .mdc-checkbox__mixedmark{border-color:var(--mdc-checkbox-disabled-selected-checkmark-color)}.mdc-checkbox .mdc-checkbox__native-control:enabled:not(:checked):not(:indeterminate):not([data-indeterminate=true])~.mdc-checkbox__background{border-color:var(--mdc-checkbox-unselected-icon-color);background-color:transparent}.mdc-checkbox .mdc-checkbox__native-control:enabled:checked~.mdc-checkbox__background,.mdc-checkbox .mdc-checkbox__native-control:enabled:indeterminate~.mdc-checkbox__background,.mdc-checkbox .mdc-checkbox__native-control[data-indeterminate=true]:enabled~.mdc-checkbox__background{border-color:var(--mdc-checkbox-selected-icon-color);background-color:var(--mdc-checkbox-selected-icon-color)}@keyframes mdc-checkbox-fade-in-background-8A000000FFF4433600000000FFF44336{0%{border-color:var(--mdc-checkbox-unselected-icon-color);background-color:transparent}50%{border-color:var(--mdc-checkbox-selected-icon-color);background-color:var(--mdc-checkbox-selected-icon-color)}}@keyframes mdc-checkbox-fade-out-background-8A000000FFF4433600000000FFF44336{0%,80%{border-color:var(--mdc-checkbox-selected-icon-color);background-color:var(--mdc-checkbox-selected-icon-color)}100%{border-color:var(--mdc-checkbox-unselected-icon-color);background-color:transparent}}.mdc-checkbox.mdc-checkbox--anim-unchecked-checked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background,.mdc-checkbox.mdc-checkbox--anim-unchecked-indeterminate .mdc-checkbox__native-control:enabled~.mdc-checkbox__background{animation-name:mdc-checkbox-fade-in-background-8A000000FFF4433600000000FFF44336}.mdc-checkbox.mdc-checkbox--anim-checked-unchecked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background,.mdc-checkbox.mdc-checkbox--anim-indeterminate-unchecked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background{animation-name:mdc-checkbox-fade-out-background-8A000000FFF4433600000000FFF44336}.mdc-checkbox:hover .mdc-checkbox__native-control:enabled:not(:checked):not(:indeterminate):not([data-indeterminate=true])~.mdc-checkbox__background{border-color:var(--mdc-checkbox-unselected-hover-icon-color);background-color:transparent}.mdc-checkbox:hover .mdc-checkbox__native-control:enabled:checked~.mdc-checkbox__background,.mdc-checkbox:hover .mdc-checkbox__native-control:enabled:indeterminate~.mdc-checkbox__background,.mdc-checkbox:hover .mdc-checkbox__native-control[data-indeterminate=true]:enabled~.mdc-checkbox__background{border-color:var(--mdc-checkbox-selected-hover-icon-color);background-color:var(--mdc-checkbox-selected-hover-icon-color)}@keyframes mdc-checkbox-fade-in-background-FF212121FFF4433600000000FFF44336{0%{border-color:var(--mdc-checkbox-unselected-hover-icon-color);background-color:transparent}50%{border-color:var(--mdc-checkbox-selected-hover-icon-color);background-color:var(--mdc-checkbox-selected-hover-icon-color)}}@keyframes mdc-checkbox-fade-out-background-FF212121FFF4433600000000FFF44336{0%,80%{border-color:var(--mdc-checkbox-selected-hover-icon-color);background-color:var(--mdc-checkbox-selected-hover-icon-color)}100%{border-color:var(--mdc-checkbox-unselected-hover-icon-color);background-color:transparent}}.mdc-checkbox:hover.mdc-checkbox--anim-unchecked-checked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background,.mdc-checkbox:hover.mdc-checkbox--anim-unchecked-indeterminate .mdc-checkbox__native-control:enabled~.mdc-checkbox__background{animation-name:mdc-checkbox-fade-in-background-FF212121FFF4433600000000FFF44336}.mdc-checkbox:hover.mdc-checkbox--anim-checked-unchecked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background,.mdc-checkbox:hover.mdc-checkbox--anim-indeterminate-unchecked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background{animation-name:mdc-checkbox-fade-out-background-FF212121FFF4433600000000FFF44336}.mdc-checkbox:not(:disabled):active .mdc-checkbox__native-control:enabled:not(:checked):not(:indeterminate):not([data-indeterminate=true])~.mdc-checkbox__background{border-color:var(--mdc-checkbox-unselected-pressed-icon-color);background-color:transparent}.mdc-checkbox:not(:disabled):active .mdc-checkbox__native-control:enabled:checked~.mdc-checkbox__background,.mdc-checkbox:not(:disabled):active .mdc-checkbox__native-control:enabled:indeterminate~.mdc-checkbox__background,.mdc-checkbox:not(:disabled):active .mdc-checkbox__native-control[data-indeterminate=true]:enabled~.mdc-checkbox__background{border-color:var(--mdc-checkbox-selected-pressed-icon-color);background-color:var(--mdc-checkbox-selected-pressed-icon-color)}@keyframes mdc-checkbox-fade-in-background-8A000000FFF4433600000000FFF44336{0%{border-color:var(--mdc-checkbox-unselected-pressed-icon-color);background-color:transparent}50%{border-color:var(--mdc-checkbox-selected-pressed-icon-color);background-color:var(--mdc-checkbox-selected-pressed-icon-color)}}@keyframes mdc-checkbox-fade-out-background-8A000000FFF4433600000000FFF44336{0%,80%{border-color:var(--mdc-checkbox-selected-pressed-icon-color);background-color:var(--mdc-checkbox-selected-pressed-icon-color)}100%{border-color:var(--mdc-checkbox-unselected-pressed-icon-color);background-color:transparent}}.mdc-checkbox:not(:disabled):active.mdc-checkbox--anim-unchecked-checked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background,.mdc-checkbox:not(:disabled):active.mdc-checkbox--anim-unchecked-indeterminate .mdc-checkbox__native-control:enabled~.mdc-checkbox__background{animation-name:mdc-checkbox-fade-in-background-8A000000FFF4433600000000FFF44336}.mdc-checkbox:not(:disabled):active.mdc-checkbox--anim-checked-unchecked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background,.mdc-checkbox:not(:disabled):active.mdc-checkbox--anim-indeterminate-unchecked .mdc-checkbox__native-control:enabled~.mdc-checkbox__background{animation-name:mdc-checkbox-fade-out-background-8A000000FFF4433600000000FFF44336}.mdc-checkbox .mdc-checkbox__background{top:calc((var(--mdc-checkbox-state-layer-size) - 18px) / 2);left:calc((var(--mdc-checkbox-state-layer-size) - 18px) / 2)}.mdc-checkbox .mdc-checkbox__native-control{top:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2);right:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2);left:calc((var(--mdc-checkbox-state-layer-size) - var(--mdc-checkbox-state-layer-size)) / 2);width:var(--mdc-checkbox-state-layer-size);height:var(--mdc-checkbox-state-layer-size)}.mdc-checkbox .mdc-checkbox__native-control:enabled:focus:focus:not(:checked):not(:indeterminate)~.mdc-checkbox__background{border-color:var(--mdc-checkbox-unselected-focus-icon-color)}.mdc-checkbox .mdc-checkbox__native-control:enabled:focus:checked~.mdc-checkbox__background,.mdc-checkbox .mdc-checkbox__native-control:enabled:focus:indeterminate~.mdc-checkbox__background{border-color:var(--mdc-checkbox-selected-focus-icon-color);background-color:var(--mdc-checkbox-selected-focus-icon-color)}.mdc-checkbox:hover .mdc-checkbox__ripple{opacity:var(--mdc-checkbox-unselected-hover-state-layer-opacity);background-color:var(--mdc-checkbox-unselected-hover-state-layer-color)}.mdc-checkbox:hover .mat-mdc-checkbox-ripple .mat-ripple-element{background-color:var(--mdc-checkbox-unselected-hover-state-layer-color)}.mdc-checkbox .mdc-checkbox__native-control:focus~.mdc-checkbox__ripple{opacity:var(--mdc-checkbox-unselected-focus-state-layer-opacity);background-color:var(--mdc-checkbox-unselected-focus-state-layer-color)}.mdc-checkbox .mdc-checkbox__native-control:focus~.mat-mdc-checkbox-ripple .mat-ripple-element{background-color:var(--mdc-checkbox-unselected-focus-state-layer-color)}.mdc-checkbox:active .mdc-checkbox__native-control~.mdc-checkbox__ripple{opacity:var(--mdc-checkbox-unselected-pressed-state-layer-opacity);background-color:var(--mdc-checkbox-unselected-pressed-state-layer-color)}.mdc-checkbox:active .mdc-checkbox__native-control~.mat-mdc-checkbox-ripple .mat-ripple-element{background-color:var(--mdc-checkbox-unselected-pressed-state-layer-color)}.mdc-checkbox:hover .mdc-checkbox__native-control:checked~.mdc-checkbox__ripple{opacity:var(--mdc-checkbox-selected-hover-state-layer-opacity);background-color:var(--mdc-checkbox-selected-hover-state-layer-color)}.mdc-checkbox:hover .mdc-checkbox__native-control:checked~.mat-mdc-checkbox-ripple .mat-ripple-element{background-color:var(--mdc-checkbox-selected-hover-state-layer-color)}.mdc-checkbox .mdc-checkbox__native-control:focus:checked~.mdc-checkbox__ripple{opacity:var(--mdc-checkbox-selected-focus-state-layer-opacity);background-color:var(--mdc-checkbox-selected-focus-state-layer-color)}.mdc-checkbox .mdc-checkbox__native-control:focus:checked~.mat-mdc-checkbox-ripple .mat-ripple-element{background-color:var(--mdc-checkbox-selected-focus-state-layer-color)}.mdc-checkbox:active .mdc-checkbox__native-control:checked~.mdc-checkbox__ripple{opacity:var(--mdc-checkbox-selected-pressed-state-layer-opacity);background-color:var(--mdc-checkbox-selected-pressed-state-layer-color)}.mdc-checkbox:active .mdc-checkbox__native-control:checked~.mat-mdc-checkbox-ripple .mat-ripple-element{background-color:var(--mdc-checkbox-selected-pressed-state-layer-color)}.mat-mdc-checkbox{display:inline-block;position:relative;-webkit-tap-highlight-color:rgba(0,0,0,0)}.mat-mdc-checkbox .mdc-checkbox__background{-webkit-print-color-adjust:exact;color-adjust:exact}.mat-mdc-checkbox._mat-animation-noopable *,.mat-mdc-checkbox._mat-animation-noopable *::before{transition:none !important;animation:none !important}.mat-mdc-checkbox label{cursor:pointer}.mat-mdc-checkbox.mat-mdc-checkbox-disabled label{cursor:default;color:var(--mat-checkbox-disabled-label-color)}.mat-mdc-checkbox label:empty{display:none}.cdk-high-contrast-active .mat-mdc-checkbox.mat-mdc-checkbox-disabled{opacity:.5}.cdk-high-contrast-active .mat-mdc-checkbox .mdc-checkbox__checkmark{--mdc-checkbox-selected-checkmark-color: CanvasText;--mdc-checkbox-disabled-selected-checkmark-color: CanvasText}.mat-mdc-checkbox .mdc-checkbox__ripple{opacity:0}.mat-mdc-checkbox-ripple,.mdc-checkbox__ripple{top:0;left:0;right:0;bottom:0;position:absolute;border-radius:50%;pointer-events:none}.mat-mdc-checkbox-ripple:not(:empty),.mdc-checkbox__ripple:not(:empty){transform:translateZ(0)}.mat-mdc-checkbox-ripple .mat-ripple-element{opacity:.1}.mat-mdc-checkbox-touch-target{position:absolute;top:50%;height:48px;left:50%;width:48px;transform:translate(-50%, -50%);display:var(--mat-checkbox-touch-target-display)}.mat-mdc-checkbox-ripple::before{border-radius:50%}.mdc-checkbox__native-control:focus~.mat-mdc-focus-indicator::before{content:""}',
        ],
        encapsulation: 2,
        changeDetection: 0,
      }));
    let i = t;
    return i;
  })();
var gs = (() => {
  let t = class t {};
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵmod = N({ type: t })),
    (t.ɵinj = O({ imports: [rn, $, $] }));
  let i = t;
  return i;
})();
var Jl = (i, t) => t[0];
function tu(i, t) {
  if ((i & 1 && (v(0, 'mat-radio-button', 13), D(1), g()), i & 2)) {
    let o = t.$implicit,
      e = Pt().$implicit;
    J('value', e[0] + '.' + o), L(), ce(o);
  }
}
function eu(i, t) {
  if (
    (i & 1 &&
      (v(0, 'div', 5)(1, 'span', 12),
      D(2),
      g(),
      fn(3, tu, 2, 2, 'mat-radio-button', 13, pr),
      g()),
    i & 2)
  ) {
    let o = t.$implicit;
    L(2), ce(o[0]), L(), bn(o[1]);
  }
}
var vs = (() => {
  let t = class t {
    constructor() {
      (this.class = 'flex flex-col gap-8'),
        (this.schemaVersions = Re([
          ['CoA', ['1.0.0']],
          ['TRK', ['1.0.0', '1.2.0']],
          ['EN10168', ['1.0.0', '1.2.0']],
          ['EN10168', ['1.0.0', '1.2.0']],
        ])),
        (this.showAllVersions = Re(!0)),
        (this.visibleSchemaVersions = vr(() =>
          this.showAllVersions()
            ? this.schemaVersions()
            : this.schemaVersions().map(([e, n]) => [e, n.slice(0, 1)])
        ));
    }
  };
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵcmp = P({
      type: t,
      selectors: [['app-form']],
      hostVars: 2,
      hostBindings: function (n, r) {
        n & 2 && wt(r.class);
      },
      standalone: !0,
      features: [j],
      decls: 40,
      vars: 0,
      consts: [
        [1, 'text-gray-900'],
        [1, 'text-gray-700', 'mb-4', 'text-sm'],
        [
          'taget',
          '_blank',
          'href',
          'https://materialidentity.org/',
          1,
          'underline',
        ],
        [
          1,
          'rounded-md',
          'border',
          'border-slate-200',
          'block',
          'px-2',
          'py-4',
        ],
        [1, 'grid', 'grid-cols-4'],
        [1, 'flex', 'flex-col'],
        [
          1,
          'grid',
          'grid-cols-4',
          'rounded-md',
          'border',
          'border-slate-200',
          'block',
          'px-2',
          'py-4',
        ],
        ['formControlName', 'pepperoni'],
        [1, 'flex-1'],
        [1, 'flex', 'gap-2', 'justify-start'],
        ['mat-raised-button', '', 'color', 'primary'],
        ['mat-stroked-button', '', 'color', 'primary'],
        [
          1,
          'ml-[var(--mdc-radio-state-layer-size)]',
          'text-sm',
          'text-gray-700',
          'mb-2',
        ],
        [1, 'example-radio-button', 3, 'value'],
      ],
      template: function (n, r) {
        n & 1 &&
          (v(0, 'section')(1, 'strong', 0),
          D(2, 'Certificate'),
          g(),
          v(3, 'p', 1),
          D(
            4,
            ' Upload the certificate you would like to validate or create the PDF of. '
          ),
          g(),
          F(5, 'app-uploader'),
          g(),
          v(6, 'section')(7, 'strong', 0),
          D(8, 'Schema'),
          g(),
          v(9, 'p', 1),
          D(10, ' Select a schema for validation. Schemas are maintained by '),
          v(11, 'a', 2),
          D(12, 'Material Identity'),
          g(),
          D(13, '. '),
          g(),
          v(14, 'mat-radio-group', 3)(15, 'div', 4),
          fn(16, eu, 5, 1, 'div', 5, Jl),
          g()()(),
          v(18, 'section')(19, 'strong', 0),
          D(20, 'Languages'),
          g(),
          v(21, 'p', 1),
          D(22, ' Select up to two languages for the PDF generation. '),
          g(),
          v(23, 'div', 6)(24, 'mat-checkbox', 7),
          D(25, 'English'),
          g(),
          v(26, 'mat-checkbox', 7),
          D(27, 'German'),
          g(),
          v(28, 'mat-checkbox', 7),
          D(29, 'Chinese'),
          g()()(),
          F(30, 'span', 8),
          v(31, 'div', 9)(32, 'button', 10)(33, 'mat-icon'),
          D(34, 'verified'),
          g(),
          D(35, ' Validate '),
          g(),
          v(36, 'button', 11)(37, 'mat-icon'),
          D(38, 'picture_as_pdf'),
          g(),
          D(39, ' Generate PDF '),
          g()()),
          n & 2 && (L(16), bn(r.visibleSchemaVersions()));
      },
      dependencies: [we, Qi, ms, Uo, on, ps, cs, gs, rn, tn, Ji],
      encapsulation: 2,
      changeDetection: 0,
    }));
  let i = t;
  return i;
})();
var _s = (() => {
  let t = class t {};
  (t.ɵfac = function (n) {
    return new (n || t)();
  }),
    (t.ɵcmp = P({
      type: t,
      selectors: [['app-root']],
      standalone: !0,
      features: [j],
      decls: 15,
      vars: 0,
      consts: [
        [1, 'flex', 'flex-col', 'bg-primary-50/10', 'h-screen'],
        [1, 'flex-1', 'flex', 'flex-col', 'overflow-auto'],
        [1, 'flex-1', 'flex', 'flex-col'],
        [1, 'container', 'mx-auto', 'py-16', 'overflow-hidden', 'flex-1'],
        [
          1,
          'shadow-xl',
          'mx-auto',
          'flex',
          'rounded-3xl',
          'px-12',
          'py-8',
          'flex-col',
          'max-w-3xl',
          'gap-8',
          'bg-white',
        ],
        [1, 'flex', 'justify-end', 'text-gray-800'],
        ['href', '/', 1, 'flex', 'gap-2', 'items-center'],
        [
          'width',
          '100%',
          'height',
          '100%',
          'viewBox',
          '0 0 64 64',
          'fill',
          'none',
          'xmlns',
          'http://www.w3.org/2000/svg',
          1,
          'w-4',
          'h-4',
        ],
        [
          'fill-rule',
          'evenodd',
          'clip-rule',
          'evenodd',
          'd',
          'M0 32C0 20.799 0 15.1984 2.17987 10.9202C4.09734 7.15695 7.15695 4.09734 10.9202 2.17987C15.1984 0 20.799 0 32 0C43.201 0 48.8016 0 53.0798 2.17987C56.8431 4.09734 59.9027 7.15695 61.8201 10.9202C64 15.1984 64 20.799 64 32C64 43.201 64 48.8016 61.8201 53.0798C59.9027 56.8431 56.8431 59.9027 53.0798 61.8201C48.8016 64 43.201 64 32 64C20.799 64 15.1984 64 10.9202 61.8201C7.15695 59.9027 4.09734 56.8431 2.17987 53.0798C0 48.8016 0 43.201 0 32ZM22 56C29.732 56 36 49.732 36 42V36H42C49.732 36 56 29.732 56 22C56 14.268 49.732 8 42 8C34.268 8 28 14.268 28 22L28 28H22C14.268 28 8 34.268 8 42C8 49.732 14.268 56 22 56ZM36 33H42C48.0751 33 53 28.0751 53 22C53 15.9249 48.0751 11 42 11C35.9249 11 31 15.9249 31 22L31 28L33 28V22C33 17.0294 37.0294 13 42 13C46.9706 13 51 17.0294 51 22C51 26.9706 46.9706 31 42 31H36V33ZM36 28L39 28H42C45.3137 28 48 25.3137 48 22C48 18.6863 45.3137 16 42 16C38.6863 16 36 18.6863 36 22V25V28ZM22 36C18.6863 36 16 38.6863 16 42C16 45.3137 18.6863 48 22 48C25.3137 48 28 45.3137 28 42V36H22Z',
          'fill',
          'currentColor',
        ],
        [
          'd',
          'M31 28H33V44C33 44.5523 32.5523 45 32 45V45C31.4477 45 31 44.5523 31 44V28Z',
          'fill',
          'currentColor',
        ],
        [1, 'font-thin', '-ml-1'],
      ],
      template: function (n, r) {
        n & 1 &&
          (v(0, 'div', 0)(1, 'div', 1)(2, 'div', 2)(3, 'div', 3)(4, 'div', 4),
          F(5, 'app-form'),
          v(6, 'footer', 5)(7, 'a', 6),
          De(),
          v(8, 'svg', 7),
          F(9, 'path', 8)(10, 'path', 9),
          g(),
          li(),
          v(11, 'span'),
          D(12, 'DMP'),
          g(),
          v(13, 'span', 10),
          D(14, 'Schema Service'),
          g()()()()()()()());
      },
      dependencies: [vs, we],
      encapsulation: 2,
    }));
  let i = t;
  return i;
})();
qr(_s, Fa).catch((i) => console.error(i));
