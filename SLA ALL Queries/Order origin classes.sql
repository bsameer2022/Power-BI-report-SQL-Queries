select st.class5_id

    , cc.class_description

    , COUNT(st.class5_id)



from P21.dbo.p21_view_ship_to st



left join (select c.class_id

                , c.class_description

            from P21.dbo.p21_view_class c

            where c.class_number=5) cc

    on st.class5_id=cc.class_id



group by st.class5_id

    , cc.class_description