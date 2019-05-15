class virtual_sequencer extends uvm_sequencer;//method two of integrating a virtual sequncer
    `uvm_component_utils(virtual_sequencer);
    
    //Handler/s for agent sequencer/s
    sequencer p_sequencer;

    function void new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : virtual_sequencer;