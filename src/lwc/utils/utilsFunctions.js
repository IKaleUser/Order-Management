import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export const TOAST_TYPE = {
    INFO    : 'info',
    ERROR   : 'error',
    SUCCESS : 'success',
    WARNING : 'warning',
};

export const showNotification = (title, message, variant) => {
    dispatchEvent(
        new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        })
    );
}