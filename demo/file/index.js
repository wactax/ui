import { API, CDN } from "./conf.js";
import { init } from "../_/SDK.js";
init(API, CDN);

import { waySet } from "../user/WAY.js";
import MAIL from "../user/WAY/MAIL.js";
waySet(MAIL);

import Box from "../_/Box.js";
import SignAuth from "../user/Sign.auth.js";

const boxAuth = (e) => {
	const box = Box(
		'<div class="auth"><header><b class="logo"></b><b class="org"><b>User.Tax</b><b><i-slogan></i-slogan></b></b></header><u-auth></u-auth></div>',
	);

	Object.assign(box.getElementsByTagName("u-auth")[0], {
		up: "up" == e?.target.className,
		next: box.close.bind(box),
	});
	return box;
};

document.querySelectorAll("u-menu a").forEach((e) => {
	e.onclick = (e) => {
		e.preventDefault();
		boxAuth(e);
	};
});

SignAuth(boxAuth);

import lang from "../_/lang.js";
import { ver } from "../user/i18n/var.js";
import AuthAgree from "../user/Auth.agree.js";

AuthAgree(async () => {
	const dialog = Box(
			'<div style="padding:0 1.8em 2em;height:calc(100vh - 8em);"><b style="height:100%;justify-content:center;display:flex;align-items:center"><svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 100 100"><circle cx="50" cy="50" fill="none" stroke="#ccc" stroke-width="10" r="35" stroke-dasharray="164.93361431346415 56.97787143782138"><animateTransform type="rotate" repeatCount="indefinite" dur="1s" values="0 50 50;360 50 50" keyTimes="0;1" attributeName="transform"/></circle></svg></b></div>',
		),
		[md, marked] = await Promise.all([
			(async () => (await fetch(CDN + `user/${ver}/law.` + lang())).text())(),
			import("//cdn.staticfile.org/marked/5.0.0/lib/marked.esm.min.js"),
		]);
	dialog.lastChild.innerHTML = marked.parse(md);
	dialog.style = "width:85vw;max-width:750px";
});

import "./i18n.js";
import "../index.js";
