class v_sequence extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(v_sequence);

    //Virtual sequencer handler
    virtual_sequencer v_seqr_hdlr;

    //Target/s sequencer handler
    sequencer p_seqr_hdlr;

    //Sequence/s handler/s
    nrst_seq reset;
    operation_seq opes;

    function void new(string name = "virtual sequence");
        super.new(name);
    endfunction : new

    task body();
        if($cast(v_seqr_hdlr, m_sequencer)) begin
            `uvm_error(get_full_name(), "Virtual Sequencer pointer failed to cast");
        end

        p_seqr_hdlr = v_seqr_hdlr.p_sequencer;

        reset = nrst_seq::type_id::create("reset");
        opes = operation_seq::type_id::create("opes");

        reset.start(p_seqr_hdlr);
        opes.start(p_seqr_hdlr);
    endtask : body
endclass : v_sequence

/*long story short: m_sequencer is a pre-defined variable of type uvm_sequencer_base. 
                    p_sequencer(or physical sequencer, which is the actual used sequencer and it can be of any name) is of a type derived from the uvm_sequencer_base
                    and to be able to access what is in it, a cast must be made with m_sequencer, to make the child the type as the parent*/