class agent_config;
        virtual sif_i agent_i;
        uvm_active_passive_enum is_active;//in the book is defined as is_active, but I didnt found a initial declaration in the UVM libraries

        function new(virtual sif_i agent_i, uvm_active_passive_enum is_active);
            this.agent_i = agent_i;
            this.is_active = is_active;
        endfunction : new

        function uvm_active_passive_enum get_is_active();
            return is_active;
        endfunction : get_is_active
endclass : sif_agent_config 