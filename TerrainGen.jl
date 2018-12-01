module TerrainGen

import Random, Statistics, Plots, RecipesBase.plot, Base.size
export Heightmap
using Statistics

mutable struct Heightmap
    pixel::Array{Float64,2}
    function Heightmap(array::Array{Float64,2})
        new(array)
    end
    
    function diamondsquare(hm::Array{Float64,2},x1::Integer,x2::Integer,y1::Integer,y2::Integer)
        #diamond
        x3=Int64((x2-x1)/2+x1) #midpoint between x1,x2
        y3=Int64((y2-y1)/2+y1) #midpoint between y1,y2
        hm[x3,y3]=mean([hm[x1,y1],hm[x2,y1],hm[x1,y2],hm[x2,y2]])+rand()/100
        #square
        #TODO wrap-around
        local hmsz=size(hm,1)
        #how do I simulate an underflow?
        #=
        #2*x1-x3<0 ? z1=hm[x3,y3] : z1=hm[2*x1-x3,y3]
        x1-(x3-x1)<0 ? z1=hm[x3,y3] : (hm[x1-(x3-x1),y3]!=0 ? z1=hm[x1-(x3-x1),y3] : z1=0)
        #x2+x3-x1>hmsz ? z2=hm[x3,y3] : z2=hm[x2+x3-x1,y3]
        x2+x3-x1>hmsz ? z2=hm[x3,y3] : (hm[x2+x3-x1,y3]!=0 ? z2=hm[x2+x3-x1,y3] : z2=0)
        #y2+y3-y1>hmsz ? z3=hm[x3,y3] : z3=hm[x3,y2+y3-y1]
        y2+y3-y1>hmsz ? z3=hm[x3,y3] : (hm[x3,y2+y3-y1]!=0 ? z3=hm[x3,y2+y3-y1] : z3=0)
        #2*y1-y3<0 ? z4=hm[x3,y3] : z4=hm[x3,2*y1-y3]
        2*y1-y3<0 ? z4=hm[x3,y3] : (hm[x3,2*y1-y3]!=0 ? z4=hm[x3,2*y1-y3] : z4=0)
        hm[x1,y3]=mean([hm[x1,y1],hm[x3,y3],hm[x1,y2],z1])+rand()/10
        hm[x2,y3]=mean([hm[x2,y1],hm[x3,y3],hm[x2,y2],z2])+rand()/10
        hm[x3,y1]=mean([hm[x1,y1],hm[x3,y3],hm[x2,y1],z3])+rand()/10
        hm[x3,y2]=mean([hm[x1,y2],hm[x3,y3],hm[x2,y2],z4])+rand()/10
        =#
        hm[x1,y3]=mean([hm[x1,y1],hm[x3,y3],hm[x1,y2]])+rand()/100
        hm[x2,y3]=mean([hm[x2,y1],hm[x3,y3],hm[x2,y2]])+rand()/100
        hm[x3,y1]=mean([hm[x1,y1],hm[x3,y3],hm[x2,y1]])+rand()/100
        hm[x3,y2]=mean([hm[x1,y2],hm[x3,y3],hm[x2,y2]])+rand()/100
        if (x2-x3)>=2 
            diamondsquare(hm,x1,x3,y1,y3)
            diamondsquare(hm,x3,x2,y1,y3)
            diamondsquare(hm,x1,x3,y3,y2)
            diamondsquare(hm,x3,x2,y3,y2)
        end
#         rmul=1
#         #diamond
#         x3=Int64((x2-x1)/2+x1) #midpoint between x1,x2
#         y3=Int64((y2-y1)/2+y1) #midpoint between y1,y2
#         z1=[hm[x1,y1],hm[x2,y1],hm[x1,y2],hm[x2,y2]]
#         hm[x3,y3]=mean(z1)#+rmul*rand()*std(z1)
#         #square
#         z2=[hm[x1,y1],hm[x3,y3],hm[x1,y2]]
#         z3=[hm[x2,y1],hm[x3,y3],hm[x2,y2]]
#         z4=[hm[x1,y1],hm[x3,y3],hm[x2,y1]]
#         z5=[hm[x1,y2],hm[x3,y3],hm[x2,y2]]
#         hm[x1,y3]=mean(z2)#+rmul*rand()*std(z2)
#         hm[x2,y3]=mean(z3)#+rmul*rand()*std(z3)
#         hm[x3,y1]=mean(z4)#+rmul*rand()*std(z4)
#         hm[x3,y2]=mean(z5)#+rmul*rand()*std(z5)
#         if (x2-x3)>=2 
#             diamondsquare(hm,x1,x3,y1,y3)
#             diamondsquare(hm,x3,x2,y1,y3)
#             diamondsquare(hm,x1,x3,y3,y2)
#             diamondsquare(hm,x3,x2,y3,y2)
#         end
    end
    function Heightmap(hmsz::Integer) #Diamond-square algorithm
        if log(2,hmsz-1)%1!=0 throw(ArgumentError("Heightmap dimension must be 2^n+1")) end
        if hmsz<=0 throw(ArgumentError("Heightmap dimension must be positive")) end
        local heightmap = zeros(Float64,hmsz,hmsz)
        heightmap[1,1]=rand()
        if hmsz>=3 
            heightmap[1,hmsz]=.4+rand()/5
            heightmap[hmsz,1]=.4+rand()/5
            heightmap[hmsz,hmsz]=.4+rand()/5
            diamondsquare(heightmap,1,hmsz,1,hmsz) 
        end
        new(heightmap)
    end
    function Heightmap(hmsz::Integer,seed::Integer)
        if seed<=0 throw(ArgumentError("Seed must be a positive integer")) end
        Random.seed!(seed)
        Heightmap(hmsz)
    end
end



end #module TerrainGen