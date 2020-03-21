if not omni then omni={} end	
if not omni.fluid then omni.fluid={} end

forbidden_boilers={}
forbidden_assembler={}
forbidden_recipe={}

function omni.fluid.excempt_boiler(boiler)
	forbidden_boilers[boiler]=true
end

function omni.fluid.excempt_assembler(boiler)
	forbidden_assembler[boiler]=true
end

function omni.fluid.excempt_recipe(boiler)
	forbidden_recipe[boiler]=true
end