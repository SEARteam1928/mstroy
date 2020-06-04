import {utils} from "@xeokit/xeokit-sdk/src/viewer/scene/utils.js";
import {Map} from "@xeokit/xeokit-sdk/src/viewer/scene/utils/Map.js";
 
const idMap = new Map();
 
class ContextMenu {
 
    constructor(cfg = {}) {
        this._id = idMap.addItem();
        this._context = null;
        this._menuElement = null;
        this._enabled = false;
        this._items = [];
        document.addEventListener("mousedown", (event) => {
            if (!event.target.classList.contains("xeokit-context-menu-item")) {
                this.hide();
            }
        });
        if (cfg.items) {
            this.items = cfg.items;
        }
        this.context = cfg.context;
        this.enabled = cfg.enabled !== false;
        this.hide();
    }
 
    set items(items) {
        this._items = items || [];
        if (this._menuElement) {
            this._menuElement.parentElement.removeChild(this._menuElement);
            this._menuElement = null;
        }
        const html = [];
        const idClass = "xeokit-context-menu-" + this._id;
        html.push('<div class="xeokit-context-menu ' + idClass + '" style="z-index:300000; position: absolute;">');
        html.push('<ul>');
        this._buildActionLinks(this._items, html);
        html.push('</ul>');
        html.push('</div>');
        const htmlStr = html.join("");
        document.querySelector('.BimView').insertAdjacentHTML('beforeend', htmlStr);
        this._menuElement = document.querySelector("." + idClass);
        this._menuElement.style["border-radius"] = 4 + "px";
        this._menuElement.style.display = 'none';
        this._menuElement.style["z-index"] = 300000;
        this._menuElement.style.background = "white";
        this._menuElement.oncontextmenu = (e) => {
            e.preventDefault();
        };
        this._bindActionLinks(this._items);
    }
 
    get items() {
        return this._items;
    }
 

    _bindActionLinks(items, ctx = {id: 0}) {
        const self = this;
        for (let i = 0; i < items.length; i++) {
            const item = items[i];
            if (utils.isArray(item)) {
                this._bindActionLinks(item, ctx);
            } else {
                item._itemElement = document.getElementById(item._itemId);
                if (!item._itemElement) {
                    console.error("ContextMenu item element not found: " + item._itemId);
                    continue;
                }
                item._itemElement.addEventListener("click", (function () {
                    const doAction = item.doAction || item.callback;
                    return function (event) {
                        if (!self._context) {
                            return;
                        }
                        doAction(self._context);
                        self.hide();
                        event.preventDefault();
                    };
                })());
            }
        }
    }

    _buildActionLinks(items, html, ctx = {id: 0}) {
        for (let i = 0; i < items.length; i++) {
            const itemsGroup = items[i];
            ctx.groupIdx = i;
            ctx.groupLen = items.length;
            this._buildActionLinks2(itemsGroup, html, ctx);
        }
    }

    _buildActionLinks2(itemsGroup, html, ctx) {
        for (let i = 0; i < itemsGroup.length; i++) {
            const item = itemsGroup[i];
            if (!item.title) {
                console.error("ContextMenu item without title - will not include in ContextMenu");
                continue;
            }
            if ((!item.doAction) && (!item.callback)) {
                console.error("ContextMenu item without doAction() or callback() - will not include in ContextMenu");
                continue;
            }
            if (item.callback) {
                console.error("ContextMenu item has deprecated 'callback' - rename to 'doAction'");
                continue;
            }
            const itemId = "xeokit-context-menu-" + this._id + "-" + ctx.id++;
            const actionTitle = item.title;
            html.push('<li id="' + itemId + '" class="xeokit-context-menu-item">' + actionTitle + '</li>');
            // html.push('<li id="' + itemId + '"xeokit-context-block-separator" style="' + ((ctx.groupIdx === ctx.groupLen - 1) || ((i < len - 1)) ? 'border-bottom: 0' : 'border-bottom: 1px solid #e4e4e4') + '"></li>');
            html.push('<div id="' + itemId + '" class="' + ((ctx.groupIdx === ctx.groupLen - 1) || ((i < itemsGroup.length - 1)) ? 'xeokit-non-bordered' : 'xeokit-context-block-separator') + '"></div>');
            item._itemId = itemId;
        }
    }
 
    set enabled(enabled) {
        this._enabled = enabled;
        if (!this._enabled) {
            this.hide();
        }
    }
 
    get enabled() {
        return this._enabled;
    }
 
    set context(context) {
        this._context = context;
    }

    get context() {
        return this._context;
    }

    show(pageX, pageY) {
        if (!this._context) {
            console.error("ContextMenu cannot be shown without a context - set context first");
            return;
        }
        if (!this._enabled || !this._menuElement) {
            return;
        }
        this._enableItems();
        this._menuElement.style.display = 'block';
        const menuHeight = this._menuElement.offsetHeight;
        const menuWidth = this._menuElement.offsetWidth;
        if ((pageY + menuHeight) > window.innerHeight) {
            pageY = window.innerHeight - menuHeight;
        }
        if ((pageX + menuWidth) > window.innerWidth) {
            pageX = window.innerWidth - menuWidth;
        }
        this._menuElement.style.left = pageX + 'px';
        this._menuElement.style.top = pageY + 'px';
    }
 
    _enableItems() {
        if (!this._context) {
            return;
        }
        for (let i = 0; i < this._items.length; i++) {
            const itemsGroup = this._items[i];
            for (let j = 0; j < itemsGroup.length; j++) {
                const item = itemsGroup[j];
                if (!item._itemElement) {
                    continue;
                }
                const getEnabled = item.getEnabled;
                if (getEnabled) {
                    const enabled = getEnabled(this._context);
                    if (!enabled) {
                        item._itemElement.classList.add("hide-context-item");
                    } else {
                        item._itemElement.classList.remove("hide-context-item");
                    }
                }
            }
        }
    }

    hide() {
        if (!this._menuElement) {
            return;
        }
        this._menuElement.style.display = 'none';
    }

    destroy() {
        if (this._menuElement) {
            this._menuElement.parentElement.removeChild(this._menuElement);
            this._menuElement = null;
        }
        if (this._id !== null) {
            idMap.removeItem(this._id);
            this._id = null;
        }
    }
}
 
export {ContextMenu};