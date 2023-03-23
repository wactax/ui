import onMount, { I18N } from "./i18n/onMount.js";
import * as C from "./i18n/code.js";

const prefix = "i-",
	TAG_LI = [];

Object.entries({
	t: class extends HTMLElement {
		connectedCallback() {
			if (!this.i) {
				this.i = this.innerText;
				this.innerText = "";
			}
			this.innerText = I18N[C[this.i]];
		}
	},
	slogan: class extends HTMLElement {
		connectedCallback() {
			this.typed?.destroy();
			const backDelay = 999,
				slogan = I18N[C.SLOGAN],
				type = I18N[C.TYPE],
				typed = (this.typed = new Typed(this, {
					strings: ["", type, slogan + "^" + 3 * backDelay],
					typeSpeed: 150,
					backSpeed: 45,
					backDelay,
					onComplete: () => {
						typed.destroy();
						delete this.typed;
						this.innerText = slogan;
					},
				}));
		}
	},
}).forEach(([name, cls]) => {
	TAG_LI.push(name);
	customElements.define(prefix + name, cls);
});

onMount(() => {
	TAG_LI.forEach((tag) => {
		[...document.getElementsByTagName(prefix + tag)].forEach((i) =>
			i.connectedCallback(),
		);
	});
});
