package pt.ipl.cloud.david.data.DataServer.repository;

import pt.ipl.cloud.david.data.DataServer.model.DataEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface DataRepository extends JpaRepository<DataEntity, UUID> {
}
