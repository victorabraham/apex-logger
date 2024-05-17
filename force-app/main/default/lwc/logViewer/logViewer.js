import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import userId from '@salesforce/user/Id';

export default class LogViewer extends LightningElement {
    subscription;
    isMuted = false;
    logs = {};
    lastTimestamp = {};

    logsAsTree = [];
    columns = [
        {
            type: 'number',
            fieldName: 'index',
            label: '#'
        },
        {
            type: 'text',
            fieldName: 'Context__c',
            label: 'Context',
            initialWidth: 100
        },
        {
            type: 'text',
            fieldName: 'elapsed',
            label: 'Elapsed (ms)'
        },
        {
            type: 'text',
            fieldName: 'Class_Name__c',
            label: 'Class'
        },
        {
            type: 'text',
            fieldName: 'Message__c',
            label: 'Message',
            wrapText: true
        },
        {
            type: 'text',
            fieldName: 'Level__c',
            label: 'Level'
        },
        // {
        //     type: 'number',
        //     fieldName: '',
        //     label: 'More'
        // }
    ];

    connectedCallback() {
        this.subscribe();
    }

    disconnectedCallback() {
        this.unsubscribe();
    }

    clearAll() {
        this.logs = {};
        this.logsAsTree = [];
    }

    async subscribe() {
        this.subscription = await subscribe('/event/Log_Event__e', -1, (message) =>
            this.receive(message)
        );

        onError((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    variant: 'error',
                    title: 'Received error from server:',
                    message: JSON.stringify(error)
                })
            );
        });
    }

    unsubscribe() {
        unsubscribe(this.subscription, (response) => { });
    }

    receive(message) {
        let log = message.data.payload;
        // templog.txl_Data__c = JSON.parse(logPayload.txl_Data__c);
        // templog = this.flatten(templog);
        // const log = templog;

        if (log.User_Id__c === userId) {
            const context = log.Context__c;

            var currentTimestamp = new Date(log.CreatedDate).getTime();
            var lastTimestamp = this.lastTimestamp[context] || currentTimestamp;
            log.elapsed = currentTimestamp - lastTimestamp;
            this.lastTimestamp[context] = lastTimestamp;

            this.logs[context] = this.logs[context] || [];
            this.logs[context].push(log);

            this.renderTree();
        }
    }

    renderTree() {
        let index = 1;
        this.logsAsTree = [];

        for (const context in this.logs) {
            let log = this.logs[context][0];
            log.index = index;

            if (this.logs[context].length > 1) {
                log._children = this.logs[context].slice(1);
            }

            this.logsAsTree.push(log);
            index++;
        }

        this.template.querySelector('lightning-tree-grid').expandAll();
    }

    toggleMute() {
        this.isMuted = !this.isMuted;

        if (this.isMuted) {
            this.unsubscribe();
        } else {
            this.subscribe();
        }
    }

    get muteIcon() {
        return this.isMuted ? 'utility:volume_off' : 'utility:volume_high';
    }

    get muteLabel() {
        return this.isMuted ? 'Unmute' : 'Mute';
    }
}