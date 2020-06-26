/*********************************************
 * OPL 12.10.0.0 Model
 * Author: Jebin
 * Creation Date: Jun 21, 2020 at 2:05:36 AM
 *********************************************/

 //parameters
 
 int r = ...;				//reactions indexed with j  
 int m =  ...;				//metabolites indexed with i
 int index_P = ...;
 int index_O2 = ...;
 int index_ATPM = ...;
 int index_glu = ...; 
 int index_biomass = ...;
 float flux_O2;
 float flux_ATPM;
 float flux_glu;
 float f;

 
 range reactions = 1..r;
 range metabolites = 1..m;
 
  
 int S[metabolites][reactions];
 float LB[reactions];
 float UB[reactions];
 float mu_LB_max[reactions] = ...;
 float mu_UB_max[reactions] = ...;
 
 //decision variables
 
 dvar boolean y[reactions]; 		//
 dvar float v[reactions]; 			//fluxes
 dvar float lambda[metabolites];	//
 dvar float+ mu_LB[reactions];
 dvar float+ mu_UB[reactions];	
  
 //constraints
 
 maximize v[index_P];
 subject to{
   
   forall(i in metabolites)
     Stoichiometry:
     sum(j in reactions) S[i][j]*v[j] == 0;
     
   forall(j in reactions)
     Lower:
     -v[j]<=-LB[j]*y[j];
     
   forall(j in reactions)
     Upper:
     v[j]<=UB[j];
     
   forall(j in reactions: j!=index_biomass)
     (sum(i in metabolites) S[i][j] * lambda[i])+mu_UB[j]-mu_LB[j] == 0;
     
   (sum(i in metabolites) S[i][index_biomass] * lambda[i])+mu_UB[index_biomass]-mu_LB[index_biomass] == 0;
   
   forall (j in reactions)
     mu_LB[j]<=mu_LB_max[j];
     
   forall (j in reactions)
     mu_UB[j]<=mu_UB_max[j];
     
   (sum(j in reactions) 1-y[j])<=K
   
   v[index_biomass] == flux_ATPM*mu_UB_max[index_ATPM]
   

 }