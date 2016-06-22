// copyright chris wanstrath
!function(e){function t(t,i,r){var o=this;return this.on("click.pjax",t,function(t){var s=e.extend({},d(i,r));s.container||(s.container=e(this).attr("data-pjax")||o),n(t,s)})}function n(t,n,i){i=d(n,i);var o=t.currentTarget;if("A"!==o.tagName.toUpperCase())throw"$.fn.pjax or $.pjax.click requires an anchor element";if(!(t.which>1||t.metaKey||t.ctrlKey||t.shiftKey||t.altKey||location.protocol!==o.protocol||location.hostname!==o.hostname||o.hash&&o.href.replace(o.hash,"")===location.href.replace(location.hash,"")||o.href===location.href+"#")){var s={url:o.href,container:e(o).attr("data-pjax"),target:o},a=e.extend({},s,i),l=e.Event("pjax:click");e(o).trigger(l,[a]),l.isDefaultPrevented()||(r(a),t.preventDefault())}}function i(t,n,i){i=d(n,i);var o=t.currentTarget;if("FORM"!==o.tagName.toUpperCase())throw"$.pjax.submit requires a form element";var s={type:o.method.toUpperCase(),url:o.action,data:e(o).serializeArray(),container:e(o).attr("data-pjax"),target:o};r(e.extend({},s,i)),t.preventDefault()}function r(t){function n(t,n){var r=e.Event(t,{relatedTarget:i});return a.trigger(r,n),!r.isDefaultPrevented()}t=e.extend(!0,{},e.ajaxSettings,r.defaults,t),e.isFunction(t.url)&&(t.url=t.url());var i=t.target,o=p(t.url).hash,a=t.context=f(t.container);t.data||(t.data={}),t.data._pjax=a.selector;var l;t.beforeSend=function(e,i){return"GET"!==i.type&&(i.timeout=0),e.setRequestHeader("X-PJAX","true"),e.setRequestHeader("X-PJAX-Container",a.selector),n("pjax:beforeSend",[e,i])?(i.timeout>0&&(l=setTimeout(function(){n("pjax:timeout",[e,t])&&e.abort("timeout")},i.timeout),i.timeout=0),void(t.requestUrl=p(i.url).href)):!1},t.complete=function(e,i){l&&clearTimeout(l),n("pjax:complete",[e,i,t]),n("pjax:end",[e,t])},t.error=function(e,i,r){var o=g("",e,t),a=n("pjax:error",[e,i,r,t]);"GET"==t.type&&"abort"!==i&&a&&s(o.url)},t.success=function(i,l,c){var d="function"==typeof e.pjax.defaults.version?e.pjax.defaults.version():e.pjax.defaults.version,f=c.getResponseHeader("X-PJAX-Version"),h=g(i,c,t);if(d&&f&&d!==f)return void s(h.url);if(!h.contents)return void s(h.url);r.state={id:t.id||u(),url:h.url,title:h.title,container:a.selector,fragment:t.fragment,timeout:t.timeout},(t.push||t.replace)&&window.history.replaceState(r.state,h.title,h.url),document.activeElement.blur(),h.title&&(document.title=h.title),a.html(h.contents);var m=a.find("input[autofocus], textarea[autofocus]").last()[0];if(m&&document.activeElement!==m&&m.focus(),v(h.scripts),"number"==typeof t.scrollTo&&e(window).scrollTop(t.scrollTo),""!==o){var y=p(h.url);y.hash=o,r.state.url=y.href,window.history.replaceState(r.state,h.title,y.href);var b=e(y.hash);b.length&&e(window).scrollTop(b.offset().top)}n("pjax:success",[i,l,c,t])},r.state||(r.state={id:u(),url:window.location.href,title:document.title,container:a.selector,fragment:t.fragment,timeout:t.timeout},window.history.replaceState(r.state,document.title));var d=r.xhr;d&&d.readyState<4&&(d.onreadystatechange=e.noop,d.abort()),r.options=t;var d=r.xhr=e.ajax(t);return d.readyState>0&&(t.push&&!t.replace&&(y(r.state.id,a.clone().contents()),window.history.pushState(null,"",c(t.requestUrl))),n("pjax:start",[d,t]),n("pjax:send",[d,t])),r.xhr}function o(t,n){var i={url:window.location.href,push:!1,replace:!0,scrollTo:!1};return r(e.extend(i,d(t,n)))}function s(e){window.history.replaceState(null,"","#"),window.location.replace(e)}function a(t){var n=t.state;if(n&&n.container){if(C&&k==n.url)return;if(r.state.id===n.id)return;var i=e(n.container);if(i.length){var o,a=S[n.id];r.state&&(o=r.state.id<n.id?"forward":"back",b(o,r.state.id,i.clone().contents()));var l=e.Event("pjax:popstate",{state:n,direction:o});i.trigger(l);var u={id:n.id,url:n.url,container:i,push:!1,fragment:n.fragment,timeout:n.timeout,scrollTo:!1};a?(i.trigger("pjax:start",[null,u]),n.title&&(document.title=n.title),i.html(a),r.state=n,i.trigger("pjax:end",[null,u])):r(u),i[0].offsetHeight}else s(location.href)}C=!1}function l(t){var n=e.isFunction(t.url)?t.url():t.url,i=t.type?t.type.toUpperCase():"GET",r=e("<form>",{method:"GET"===i?"GET":"POST",action:n,style:"display:none"});"GET"!==i&&"POST"!==i&&r.append(e("<input>",{type:"hidden",name:"_method",value:i.toLowerCase()}));var o=t.data;if("string"==typeof o)e.each(o.split("&"),function(t,n){var i=n.split("=");r.append(e("<input>",{type:"hidden",name:i[0],value:i[1]}))});else if("object"==typeof o)for(key in o)r.append(e("<input>",{type:"hidden",name:key,value:o[key]}));e(document.body).append(r),r.submit()}function u(){return(new Date).getTime()}function c(e){return e.replace(/\?_pjax=[^&]+&?/,"?").replace(/_pjax=[^&]+&?/,"").replace(/[\?&]$/,"")}function p(e){var t=document.createElement("a");return t.href=e,t}function d(t,n){return t&&n?n.container=t:n=e.isPlainObject(t)?t:{container:t},n.container&&(n.container=f(n.container)),n}function f(t){if(t=e(t),t.length){if(""!==t.selector&&t.context===document)return t;if(t.attr("id"))return e("#"+t.attr("id"));throw"cant get selector for pjax container!"}throw"no pjax container for "+t.selector}function h(e,t){return e.filter(t).add(e.find(t))}function m(t){return e.parseHTML(t,document,!0)}function g(t,n,i){var r={};if(r.url=c(n.getResponseHeader("X-PJAX-URL")||i.requestUrl),/<html/i.test(t))var o=e(m(t.match(/<head[^>]*>([\s\S.]*)<\/head>/i)[0])),s=e(m(t.match(/<body[^>]*>([\s\S.]*)<\/body>/i)[0]));else var o=s=e(m(t));if(0===s.length)return r;if(r.title=h(o,"title").last().text(),i.fragment){if("body"===i.fragment)var a=s;else var a=h(s,i.fragment).first();a.length&&(r.contents=a.contents(),r.title||(r.title=a.attr("title")||a.data("title")))}else/<html/i.test(t)||(r.contents=s);return r.contents&&(r.contents=r.contents.not(function(){return e(this).is("title")}),r.contents.find("title").remove(),r.scripts=h(r.contents,"script[src]").remove(),r.contents=r.contents.not(r.scripts)),r.title&&(r.title=e.trim(r.title)),r}function v(t){if(t){var n=e("script[src]");t.each(function(){var t=this.src,i=n.filter(function(){return this.src===t});if(!i.length){var r=document.createElement("script");r.type=e(this).attr("type"),r.src=e(this).attr("src"),document.head.appendChild(r)}})}}function y(e,t){for(S[e]=t,D.push(e);N.length;)delete S[N.shift()];for(;D.length>r.defaults.maxCacheLength;)delete S[D.shift()]}function b(e,t,n){var i,r;S[t]=n,"forward"===e?(i=D,r=N):(i=N,r=D),i.push(t),(t=r.pop())&&delete S[t]}function x(){return e("meta").filter(function(){var t=e(this).attr("http-equiv");return t&&"X-PJAX-VERSION"===t.toUpperCase()}).attr("content")}function w(){e.fn.pjax=t,e.pjax=r,e.pjax.enable=e.noop,e.pjax.disable=T,e.pjax.click=n,e.pjax.submit=i,e.pjax.reload=o,e.pjax.defaults={timeout:650,push:!0,replace:!1,type:"GET",dataType:"html",scrollTo:0,maxCacheLength:20,version:x},e(window).on("popstate.pjax",a)}function T(){e.fn.pjax=function(){return this},e.pjax=l,e.pjax.enable=w,e.pjax.disable=e.noop,e.pjax.click=e.noop,e.pjax.submit=e.noop,e.pjax.reload=function(){window.location.reload()},e(window).off("popstate.pjax",a)}var C=!0,k=window.location.href,E=window.history.state;E&&E.container&&(r.state=E),"state"in window.history&&(C=!1);var S={},N=[],D=[];e.inArray("state",e.event.props)<0&&e.event.props.push("state"),e.support.pjax=window.history&&window.history.pushState&&window.history.replaceState&&!navigator.userAgent.match(/((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/),e.support.pjax?w():T()}(jQuery);