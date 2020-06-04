import User from '../user';
import { Notify, uid } from 'quasar';

class Message {
    constructor() {
        if (typeof Message.instance === 'object') {
            return Message.instance;
        }

        Message.instance = this;

        this.uid = uid;
        this.messages = [];
        this.notify = null;

        this.readMessagesUID = [];

        this.autoInit();
    }

    addMessage({ login, uid, text }, immediate = true) {
        this.messages.push({ login, uid, text });

        let userLogin = User.userInfo && User.userInfo.username;

        if (this.compareLogins(login, userLogin) && !this.notify && immediate) {
            this.showMessages();
        }
    }

    compareLogins(login1, login2) {
        if (!login1 || !login2) return;

        login2 = login2.toLowerCase().trim();

        if (login1 instanceof Array) {
            login1 = login1.map(login => login.toLowerCase().trim());
            return login1.includes(login2);
        } else {
            login1 = login1.toLowerCase().trim();
        }

        return login1 === login2;
    }

    showMessages() {
        let index;
        let message;
        let userLogin = User.userInfo && User.userInfo.username;

        for (let i = 0; i < this.messages.length; i++) {
            let mess = this.messages[i];

            if (this.compareLogins(mess.login, userLogin)) {
                if (!this.isRead(mess.uid)) {
                    index = i;
                    message = mess;

                    break;
                } else {
                    this.markRead(i);
                }
            }
        }

        if (message) {
            this.notify = Notify.create({
                icon: 'info',
                color: 'primary',
                textColor: 'white',
                message: message.text,
                position: 'bottom-left',
                timeout: 0,
                multiLine: true,
                classes: 'messageNotify',
                onDismiss: () => this.onDismiss(index),
                actions: [
                    {
                        label: 'Закрыть',
                        icon: 'close',
                        color: 'white'
                    }
                ]
            });
        }
    }

    onDismiss = index => {
        console.log('onDismiss: ', index);

        if (typeof index === 'number') {
            this.markRead(index);
        }

        this.notify = null;

        this.showMessages();
    };

    isRead = uid => {
        return this.readMessagesUID.includes(uid);
    };

    markRead = index => {
        let readMessage = this.messages.splice(index, 1);
        let { uid } = readMessage[0];

        if (!this.isRead(uid)) {
            this.readMessagesUID.push(uid);
            window.localStorage.setItem('messagesUID', JSON.stringify(this.readMessagesUID));
        }
    };

    autoInit() {
        let restoredUID = window.localStorage.getItem('messagesUID');
        if (!restoredUID) {
            restoredUID = [];
            window.localStorage.setItem('messagesUID', JSON.stringify(restoredUID));
        } else {
            try {
                restoredUID = JSON.parse(restoredUID);
            } catch (error) {
                restoredUID = [];
            }
        }

        this.readMessagesUID = restoredUID;
    }
}

// TODO: Убрать на проде
if (process.env.DEV) {
    window.Message = new Message();

    window.Message.addMessage(
        {
            login: ['Тарасов Е.А.'],
            uid: '62bf1617-fd31-45f3-b5cc-87ceb23d07a5',
            text: `Приветствую, Евгений!
    - Ваша проблема с закрытием модалок при клике вне самой модалки устранена!
    - В модалку создания новой сессии добавлена стартовая дата по умолчанию.`
        },
        false
    );
}

export default new Message();
