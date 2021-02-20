import {LightningElement, track, wire} from 'lwc';
import getAllPricebookEntries from '@salesforce/apex/PricebookManagerController.getAllPricebookEntries';
import updateEditedPricebookEntries from '@salesforce/apex/PricebookManagerController.updateEditedPricebookEntries';
import {refreshApex} from '@salesforce/apex';
import {cloneObject, showToast} from "c/utils";


export default class PricebookEntriesEditor extends LightningElement {

    label = {
        Error: 'Error',
        Success: 'Success',
        Successful_Update: 'Successfully Updated!',
        Product_Code: 'Product Code',
        Active: 'Active',
        Product_Name: 'Product Name',
        List_Price: 'List Price'
    };

    @track columns = [
        {label: this.label.Product_Name, fieldName: 'Name', editable: false, type: 'text'},
        {label: this.label.Product_Code, fieldName: 'ProductCode', editable: false, type: 'text'},
        {
            label: this.label.List_Price,
            fieldName: 'UnitPrice',
            editable: true,
            type: 'currency',
            cellAttributes: {alignment: 'left'}
        },
        {label: this.label.Active, fieldName: 'IsActive', editable: true, type: 'boolean'}
    ];

    @track showSpinner = true;
    @track draftValues = [];
    @track listView;

    @wire(getAllPricebookEntries)
    wiredListView(result) {
        this.listView = result;
        if (result.data) {
            this.showSpinner = false;
        }
    }

    get isListViewEmpty() {
        return (this.listView === null || this.listView.length === 0) && !this.showSpinner;
    }

    handleSave = () => {
        updateEditedPricebookEntries({pricebookEntries: this.draftValues})
            .then(() => {
                showToast(this, this.label.Success, this.label.Successful_Update, 'success');
                this.draftValues = [];
                return refreshApex(this.listView);
            }).catch(error => {
                showToast(this, this.label.Error, error.body.message, 'error');
        });
    };

    handleCellChange = (event) => {
        let cellChangeValue = event.detail.draftValues[0];
        if (cellChangeValue.UnitPrice === '' || cellChangeValue.UnitPrice === null) {
            cellChangeValue.UnitPrice = 0;
        }
        let isAdded = false;
        this.draftValues = cloneObject(this.draftValues.map(item => {
            if (item.Id === cellChangeValue.Id) {
                isAdded = true;
                return {...item, ...cellChangeValue};
            }
            return item;
        }));
        if (!isAdded) {
            this.draftValues.push(cloneObject(cellChangeValue));
        }
    };

    handleCancel = (event) => {
        event.preventDefault();
        this.draftValues = [];
    };
}