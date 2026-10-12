loaded_h_0(function(_){var window=this;
_.v("lOO0Vd");
_.rob=new _.Jo(_.YSa);
_.w();
var tob;tob=function(a){if(a.aRc){let b=Date.now()-a.zpe;return a.aRc(a.vIb+1,b)}return Math.random()*Math.min(a.F0d*Math.pow(a.pdc,a.vIb),a.Q8d)};_.uob=function(a){if(!a.h6a())throw Error("Ye`"+a.Jlb);++a.vIb;a.odc=tob(a)};_.vob=class{constructor(a,b,c,d,e,f){this.Jlb=a;this.F0d=b;this.pdc=c;this.Q8d=d;this.hie=e;this.aRc=f||null;this.zpe=Date.now();this.vIb=0;this.odc=tob(this)}boc(){return this.vIb}h6a(a){return this.vIb>=this.Jlb?!1:a!=null?!!this.hie[a]:!0}};
_.v("P6sQOc");
var wob=function(a){var b={};_.Ka(a.Aa(),e=>{b[e]=!0});var c=a.Ba(),d=a.Ca();return new _.vob(a.wa(),_.ve(c.getSeconds())*1E3,a.oa(),_.ve(d.getSeconds())*1E3,b)},xob=new _.Uq("retryConfigOverrides"),yob=function(a,b,c,d){return c.then(e=>e,e=>{if(e instanceof _.pya){if(!e.status||!d.h6a(_.Ge(e.status,1)))throw e;}else if("function"==typeof _.Fkb&&e instanceof _.Fkb)switch(e.ka){case 103:case 7:case 10:case 101:case 105:case 408:case 425:case 429:case 502:case 503:case 504:break;default:throw e;}if(d&&
!d.h6a())return _.Mh(e);var f=d.odc;return(new _.Tg(g=>{setTimeout(g,f)})).then(()=>{_.uob(d);var g=d.boc();b=b.zv(_.kXa,g);return yob(a,b,a.fetch(b),d)})})};
_.ig(class{constructor(){this.ka=_.Sf(_.qob);this.oa=_.Sf(_.rob);this.logger=null;var a=_.Sf(_.hjb);this.fetch=a.fetch.bind(a)}O5a(a,b){if(this.oa.getType(a.Wq())!==1)return new _.ljb(a,null,0);var c=this.ka.policy,d=_.Vq(a,xob),e=null;if(d){e={};if(d.xIb)for(var f of d.xIb)e[f]=!0;else if(c)for(var g of c.Aa())e[g]=!0;f=1;g=0;let h=Infinity,k=2;if(c){f=c.wa()||f;let l=c.Ia()?.getSeconds();g=_.ve(c.Ka().getSeconds())*1E3;h=l!=null?_.ve(l)*1E3:h;k=c.oa()||k}e=new _.vob(d.maxAttempts??f,d.qsc??g,d.feb??
k,d.bxc??h,e,d.cFd)}else c&&(e=wob(c));e&&e.h6a()?(b=yob(this,a,b,e),a=new _.ljb(a,b,2)):a=new _.ljb(a,null,0);return a}},_.sob);
_.w();
});
// Google Inc.
