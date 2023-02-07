import { LightningElement, track, wire, api } from 'lwc';
import getCustomer from '@salesforce/apex/LWCCustomersListViewController.getCustomer';

export default class CustomerDetailView extends LightningElement {
    recId;
    activeSections = ['A', 'B', 'C', 'D', 'name'];
    activeSectionsMessage = '';
    CustomerName;
    Type;
    custLst = [
        {
            Name: 'Process 1',
            Type: 'Process Type 1'
        },
        {
            Name: 'Process 2',
            Type: 'Process Type 2'
        },
        {
            Name: 'Process 2',
            Type: 'Process Type 2'
        } ,
        {
            Name: 'Process 2',
            Type: 'Process Type 2'
        } ,
        {
            Name: 'Process 2',
            Type: 'Process Type 2'
        }
    ];

    configAreaLst = [
        {
            Name: 'Fields',
            Source: 43,
            Target: 35
        },
        {
            Name: 'Layout',
            Source: 0,
            Target: 0
        },
        {
            Name: 'List View',
            Source: 0,
            Target: 0
        },
        {
            Name: 'Lightning Page',
            Source: 0,
            Target: 0
        },
        {
            Name: 'Groups',
            Source: 0,
            Target: 0
        },
        {
            Name: 'Permission Set/Profile',
            Source: 0,
            Target: 0
        },
        {
            Name: 'Sharing Settings',
            Source: 0,
            Target: 0
        },
        {
            Name: 'Reports',
            Source: 0,
            Target: 0
        },
        {
            Name: 'Dashboards',
            Source: 0,
            Target: 0
        }
    ];

    @api
    get customerrecid() {
        return this.recId;
    }
    set customerrecid(id) {
        console.log('cusotmer id in child component-----::>> ' + id);
        if(id != undefined) {
            getCustomer({customerId : id}).then(result => {
                console.log('customer:: ', result);
                // this.oppRecords = result;
                this.CustomerName = result.Name;
                this.Type = result.CustomerStatusType;

            }).catch(error => {
                console.log(error);
            });
        }
        this.recId = id;
    }


    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
}