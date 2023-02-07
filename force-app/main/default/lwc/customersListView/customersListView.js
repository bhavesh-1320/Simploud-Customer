import { LightningElement, wire, track , api } from 'lwc';
import getAllCustomers from '@salesforce/apex/LWCCustomersListViewController.getAllCustomers';
import getCustomerRelatedConfigItem from '@salesforce/apex/LWCCustomersListViewController.getCustomerRelatedConfigItem';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'View', name: 'view' },
    { label: 'Open CI', name: 'open_ci' },
    { label: 'Back Up', name: 'back_up' },
];

const columns = [
    { label: 'Customer Name', fieldName: 'Name' },
    { label: 'Type', fieldName: 'CustomerStatusType' },
    { label: 'Country', fieldName: '' },
    { label: 'Status', fieldName: '' },
    { label: 'Customer Rating', fieldName: '' },
    { label: 'Open Items', fieldName: '' },
    { label: 'Last Activity', fieldName: '' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class CustomersListView extends NavigationMixin(LightningElement) {
    data = [];
    columns = columns;
    record = {};
    showCustomerList = true;
    showCustomerDetail = false;
    renderTable = true;
    custLst;
    customerId;
    wiredRecs;

    @wire(getAllCustomers) getAllCustomersLst(wiredRecords) {
        this.wiredRecs = wiredRecords;
        console.log('result.data:: ', wiredRecords);
        this.custLst = wiredRecords.data;
    }

    setCustomerId(event) {
        console.log('clicked on this customer Id:: ', event.currentTarget.dataset.recid);
        this.customerId = event.currentTarget.dataset.recid;
        this.showCustomerDetail = true;
        this.showCustomerList = false;
        this.renderTable = false;
    }

    // eslint-disable-next-line @lwc/lwc/no-async-await
    async connectedCallback() {
        this.data = await getAllCustomers()
        .then(result => {
            console.log('result ====> ', result);

            return result;
        })
        .catch(error => {
            console.log('Error ====> '+ JSON.stringify(error));
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: error.message,
                variant: 'error'
            }),);
        });

    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'view':
                console.log('view clicked for:: ', row.Name);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'view clicked for:: ' + row.Name,
                    variant: 'success'
                }),);
                break;
            case 'open_ci':
                console.log('open_ci clicked for:: ', row);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Open CI clicked for:: ' + row.Name,
                    variant: 'success'
                }),);
                break;
            case 'back_up':
                console.log('back_up clicked for:: ', row);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Back Up clicked for:: ' + row.Name,
                    variant: 'success'
                }),);
                break;
            default:
        }
    }

    deleteRow(row) {
        const { id } = row;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    showRowDetails(row) {
        this.record = row;
    }

    handleRadioBtnChange(event) {
        // if (event.target.checked)
        // {
        //     accIds.add(event.target.dataset.id);
        //     console.log('added:: ' + event.target.dataset.id);
        // }
        // else
        // {
        //     accIds.delete(event.target.dataset.id);
        //     console.log('removed:: ' + event.target.dataset.id);
        // }
        // this.selectedRecords = Array.from(accIds);
    }

    openCIAction(event) {
        console.log('event.currentTarget.dataset.recid:: in openCIAction :: ' + event.currentTarget.dataset.recid);
        getCustomerRelatedConfigItem({customerId: event.currentTarget.dataset.recid})
        .then(result => {
            console.log('getCustomerRelatedConfigItem result:: ', result);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result,
                    actionName: 'view'
                }
            });
        })
        .catch(error => {
            console.log(error);
        });

    }

    backUpAction(event) {
        console.log('event.currentTarget.dataset.recid:: In backup :: ' + event.currentTarget.dataset.recid);

    }
}