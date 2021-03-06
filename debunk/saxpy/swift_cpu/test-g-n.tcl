
# Generated by stc version 0.2.0
# date                    : 2014/05/03 13:16:18
# Turbine version         : 0.3.0
# Input filename          : /home/skrieder/gemtc/debunk/saxpy/swift_cpu/test-g-n.swift
# Output filename         : /home/skrieder/gemtc/debunk/saxpy/swift_cpu
# STC home                : /home/skrieder/sfw/stc
# Turbine home            : /home/skrieder/sfw/turbine
# Compiler settings:
# stc.auto-declare              : true
# stc.c_preprocess              : true
# stc.checkpointing             : true
# stc.codegen.no-stack          : true
# stc.codegen.no-stack-vars     : true
# stc.compiler-debug            : true
# stc.debugging                 : COMMENTS
# stc.ic.output-file            : 
# stc.input_filename            : test-g-n.swift
# stc.log.file                  : 
# stc.log.trace                 : false
# stc.must_pass_wait_vars       : true
# stc.opt.algebra               : false
# stc.opt.array-build           : true
# stc.opt.batch-refcounts       : true
# stc.opt.cancel-refcounts      : true
# stc.opt.constant-fold         : true
# stc.opt.controlflow-fusion    : true
# stc.opt.dead-code-elim        : true
# stc.opt.disable-asserts       : false
# stc.opt.expand-dataflow-ops   : true
# stc.opt.expand-loop-threshold-insts: 256
# stc.opt.expand-loop-threshold-iters: 16
# stc.opt.expand-loops          : true
# stc.opt.finalized-var         : true
# stc.opt.flatten-nested        : true
# stc.opt.full-unroll           : false
# stc.opt.function-inline       : false
# stc.opt.function-inline-threshold: 500
# stc.opt.function-signature    : true
# stc.opt.hoist                 : true
# stc.opt.hoist-refcounts       : true
# stc.opt.loop-simplify         : true
# stc.opt.max-iterations        : 10
# stc.opt.merge-refcounts       : true
# stc.opt.piggyback-refcounts   : true
# stc.opt.pipeline              : false
# stc.opt.reorder-insts         : false
# stc.opt.shared-constants      : true
# stc.opt.unroll-loop-threshold-insts: 192
# stc.opt.unroll-loop-threshold-iters: 8
# stc.opt.unroll-loops          : true
# stc.opt.value-number          : true
# stc.opt.wait-coalesce         : true
# stc.output_filename           : 
# stc.preproc.force-cpp         : false
# stc.preproc.force-gcc         : false
# stc.preprocess_only           : false
# stc.profile                   : false
# stc.refcounting               : true
# stc.rpath                     : 
# stc.stc_home                  : /home/skrieder/sfw/stc
# stc.turbine.version           : 0.3.0
# stc.turbine_home              : /home/skrieder/sfw/turbine
# stc.version                   : 0.2.0

# Metadata:

package require turbine 0.3.0
namespace import turbine::*


proc swift:constants {  } {
    turbine::c::log "function:swift:constants"
}

package require g 0.0


proc swift:main {  } {
    turbine::c::log "enter function: main"
    set stack 0
    # Var: $string optv:__t0 VALUE_OF [string:__t0]
    # Var: $int optv:num_sims VALUE_OF [int:num_sims]
    # Var: $string optv:__t2 VALUE_OF [string:__t2]
    # Var: $int optv:np VALUE_OF [int:np]
    # Var: $string optv:__t4 VALUE_OF [string:__t4]
    # Var: $int optv:nd VALUE_OF [int:nd]
    # Swift l.13: assigning expression to num_sims
    set optv:__t0 [ turbine::argv_get_impl "num_sims" ]
    set optv:num_sims [ turbine::check_str_int ${optv:__t0} ]
    # Swift l.14: assigning expression to np
    set optv:__t2 [ turbine::argv_get_impl "np" ]
    set optv:np [ turbine::check_str_int ${optv:__t2} ]
    # Swift l.15: assigning expression to nd
    set optv:__t4 [ turbine::argv_get_impl "nd" ]
    set optv:nd [ turbine::check_str_int ${optv:__t4} ]
    # Swift l.18: assigning expression to sum
    main-range0:outer ${stack} ${optv:nd} ${optv:np} 1 ${optv:num_sims} 1
}


proc main-range0:outer { stack optv:nd optv:np tcltmp:lo tcltmp:hi tcltmp:inc } {
    if { [ expr { ${tcltmp:lo} > ${tcltmp:hi} } ] } {
        return
    }
    while {1} {
        set tcltmp:itersleft [ expr { max(0,(${tcltmp:hi} - ${tcltmp:lo}) / ${tcltmp:inc} + 1) } ]
        if { [ expr { ${tcltmp:itersleft} <= 64 } ] } {
            main-range0:inner ${stack} ${optv:nd} ${optv:np} ${tcltmp:lo} ${tcltmp:hi} ${tcltmp:inc}
            return
        } else {
            set tcltmp:skip [ expr { ${tcltmp:inc} * max(64,((${tcltmp:itersleft} - 1) / 16) + 1) } ]
            for { set tcltmp:splitstart [ expr { ${tcltmp:lo} + ${tcltmp:skip} } ] } { ${tcltmp:splitstart} <= ${tcltmp:hi} } { incr tcltmp:splitstart ${tcltmp:skip} } {
                set tcltmp:splitend [ expr { min(${tcltmp:hi},${tcltmp:splitstart} + ${tcltmp:skip} - 1) } ]
                set tcltmp:prio [ turbine::get_priority ]
                turbine::set_priority ${tcltmp:prio}
                adlb::spawn 1 "command main-range0:outer ${stack} ${optv:nd} ${optv:np} ${tcltmp:splitstart} ${tcltmp:splitend} ${tcltmp:inc}"
                turbine::reset_priority
            }
            set tcltmp:hi [ expr { ${tcltmp:lo} + ${tcltmp:skip} - 1 } ]
        }
    }
}


proc main-range0:inner { stack optv:nd optv:np tcltmp:lo tcltmp:hi tcltmp:inc } {
    for { set v:i ${tcltmp:lo} } { ${v:i} <= ${tcltmp:hi} } { incr v:i ${tcltmp:inc} } {
        set tcltmp:prio [ turbine::get_priority ]
        turbine::set_priority ${tcltmp:prio}
        adlb::spawn 0 "-1 main-call_sync-g ${stack} ${optv:nd} ${optv:np}"
        turbine::reset_priority
    }
}


proc main-call_sync-g { stack optv:nd optv:np } {
    # Var: $int optv:sum VALUE_OF [int:sum]
    set optv:sum [ g ${optv:np} ${optv:nd} ]
}


proc f:g { stack u:sum u:i1 u:i2 dr:location } {
    turbine::c::log "enter function: g"
    turbine::read_refcount_incr ${u:i1} 1
    turbine::read_refcount_incr ${u:i2} 1
    turbine::rule [ list ${u:i1} ${u:i2} ] "g-argwait ${stack} ${u:sum} ${u:i2} ${u:i1}" target ${dr:location} type ${::turbine::WORK}
}


proc g-argwait { stack u:sum u:i2 u:i1 } {
    # Var: $int v:i1 VALUE_OF [int:i1]
    # Var: $int v:i2 VALUE_OF [int:i2]
    # Var: $int v:sum VALUE_OF [int:sum]
    set v:i1 [ turbine::retrieve_integer ${u:i1} CACHED 1 ]
    set v:i2 [ turbine::retrieve_integer ${u:i2} CACHED 1 ]
    set v:sum [ g ${v:i1} ${v:i2} ]
    turbine::store_integer ${u:sum} ${v:sum}
}

turbine::defaults
turbine::init $engines $servers "Swift"
turbine::enable_read_refcount
turbine::xpt_init
turbine::check_constants "WORKER" ${turbine::WORK_TASK} 0 "CONTROL" ${turbine::CONTROL_TASK} 1 "ADLB_RANK_ANY" ${adlb::RANK_ANY} -100
turbine::start swift:main swift:constants
turbine::finalize
turbine::xpt_finalize

