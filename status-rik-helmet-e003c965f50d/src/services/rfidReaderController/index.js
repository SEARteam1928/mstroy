class RfidReaderController {
    constructor() {
        if (typeof RfidReaderController.instance === 'object') {
            return RfidReaderController.instance;
        }
        RfidReaderController.instance = this;

        this.rfidUrl = 'ws://localhost:8090/ws';
        this.socket = null;
        this.router = null;
        this.store = null;
        this.storeModuleName = 'RfidController';

        this.handlers = [
            {
                regex: /^\s*Em-Marine.*\s+(?<cardId>[0-9,]+)\s*$/iu,
                handler: this.onCardRead
            },
            {
                regex: /\s*no\s*card\s*/iu,
                handler: this.onNoCard
            }
        ];

        this.init();
    }

    init = () => {
        if (this.socket) {
            if (this.socket.readyState === this.socket.CONNECTING || this.socket.readyState === this.socket.OPEN) {
                this.socket.close();
            }

            this.onNoCard();
        }

        this.socket = new WebSocket(this.rfidUrl);
        this.socket.addEventListener('open', this.onOpen);
        this.socket.addEventListener('close', this.onClose);
        this.socket.addEventListener('error', this.onError);
        this.socket.addEventListener('message', this.onMessage);
    };

    setStore = store => {
        this.store = store;

        return this;
    };
    setRouter = router => {
        this.router = router;

        return this;
    };

    onOpen = () => {
        if (!this.store) return;

        this.store.commit(`${this.storeModuleName}/setConnected`, true);
    };
    onClose = () => {
        if (!this.store) return;

        this.store.commit(`${this.storeModuleName}/setConnected`, false);
    };
    onError = () => {
        if (!this.store) return;

        this.store.commit(`${this.storeModuleName}/setConnected`, false);
    };
    onMessage = e => {
        let { data: msg } = e;

        for (let index = 0; index < this.handlers.length; index++) {
            let { regex, handler } = this.handlers[index];
            let match = msg.match(regex);
            if (match) {
                handler(match);
                break;
            }
        }
    };

    // Обработчики сообщений
    onCardRead = match => {
        let { cardId } = match.groups;
        this.store.commit(`${this.storeModuleName}/setRfidValue`, null);
        setTimeout(() => {
            this.store.commit(`${this.storeModuleName}/setRfidValue`, cardId);
            this.store.commit(`${this.storeModuleName}/setNoCard`, false);
        }, 0);
    };

    onNoCard = () => {
        this.store.commit(`${this.storeModuleName}/setRfidValue`, null);
        this.store.commit(`${this.storeModuleName}/setNoCard`, true);
    };
}

// TODO: Убрать на проде
if (process.env.DEV) {
    window.RfidReaderController = new RfidReaderController();
}

export default new RfidReaderController();
